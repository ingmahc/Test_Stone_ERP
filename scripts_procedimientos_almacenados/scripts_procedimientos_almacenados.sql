USE [Stone_ERP]
GO
/****** Object:  StoredProcedure [dbo].[AssignRolePermission]    Script Date: 3/11/2024 1:54:19 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[AssignRolePermission]
    @RoleId BIGINT,
    @PermissionId BIGINT,
    @EntityCatalogId BIGINT,
    @Include BIT
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        BEGIN TRANSACTION;

        -- Verificar existencia del rol
        IF NOT EXISTS (SELECT 1 FROM Role WHERE id_role = @RoleId)
        BEGIN
            RAISERROR('El rol no existe.', 16, 1);
            ROLLBACK TRANSACTION;
            RETURN;
        END

        -- Verificar existencia del permiso
        IF NOT EXISTS (SELECT 1 FROM Permission WHERE id_permi = @PermissionId)
        BEGIN
            RAISERROR('El permiso no existe.', 16, 1);
            ROLLBACK TRANSACTION;
            RETURN;
        END

        -- Verificar existencia de la entidad
        IF NOT EXISTS (SELECT 1 FROM EntityCatalog WHERE id_entit = @EntityCatalogId)
        BEGIN
            RAISERROR('La entidad no existe.', 16, 1);
            ROLLBACK TRANSACTION;
            RETURN;
        END

        -- Insertar o actualizar permiso para el rol
        IF NOT EXISTS (SELECT 1 FROM PermiRole WHERE role_id = @RoleId AND permission_id = @PermissionId AND entitycatalog_id = @EntityCatalogId)
        BEGIN
            INSERT INTO PermiRole (role_id, permission_id, entitycatalog_id, perol_include)
            VALUES (@RoleId, @PermissionId, @EntityCatalogId, @Include);

            DECLARE @RoleName NVARCHAR(255) = (SELECT role_name FROM Role WHERE id_role = @RoleId);
            DECLARE @PermName NVARCHAR(255) = (SELECT name FROM Permission WHERE id_permi = @PermissionId);
            DECLARE @EntityName NVARCHAR(255) = (SELECT entit_name FROM EntityCatalog WHERE id_entit = @EntityCatalogId);

            DECLARE @Message NVARCHAR(400);
            SET @Message = N'Permiso ''' + @PermName + ''' ' + CASE WHEN @Include = 1 THEN 'asignado' ELSE 'revocado' END + 
                           ' para el rol ''' + @RoleName + ''' en la entidad ''' + @EntityName + '''.';

            PRINT @Message;
        END
        ELSE
        BEGIN
            RAISERROR('El permiso ya está asignado al rol en la entidad especificada.', 16, 1);
            ROLLBACK TRANSACTION;
            RETURN;
        END

        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        DECLARE @ErrorMessage NVARCHAR(4000);
        DECLARE @ErrorSeverity INT;
        DECLARE @ErrorState INT;

        SELECT @ErrorMessage = ERROR_MESSAGE(),
               @ErrorSeverity = ERROR_SEVERITY(),
               @ErrorState = ERROR_STATE();

        RAISERROR(@ErrorMessage, @ErrorSeverity, @ErrorState);
    END CATCH
END
GO



/****** Object:  StoredProcedure [dbo].[AssignUserPermission]    Script Date: 3/11/2024 1:54:19 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[AssignUserPermission]
    @UserCompanyId BIGINT,
    @PermissionId BIGINT,
    @EntityCatalogId BIGINT,
    @Include BIT,
    @Message NVARCHAR(4000) OUTPUT
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        BEGIN TRANSACTION;

        -- Validar si el usuario existe
        IF NOT EXISTS (SELECT 1 FROM UserCompany WHERE company_id = @UserCompanyId)
        BEGIN
            SET @Message = 'El usuario especificado no existe.';
            ROLLBACK TRANSACTION;
            RETURN;
        END

        -- Validar si el permiso existe
        IF NOT EXISTS (SELECT 1 FROM Permission WHERE id_permi = @PermissionId)
        BEGIN
            SET @Message = 'El permiso especificado no existe.';
            ROLLBACK TRANSACTION;
            RETURN;
        END

        -- Validar si la entidad existe
        IF NOT EXISTS (SELECT 1 FROM EntityCatalog WHERE id_entit = @EntityCatalogId)
        BEGIN
            SET @Message = 'La entidad especificada no existe.';
            ROLLBACK TRANSACTION;
            RETURN;
        END

        -- Obtener nombres descriptivos
        DECLARE @CompanyName NVARCHAR(255), @PermissionName NVARCHAR(255), @EntityName NVARCHAR(255);
        SELECT 
			@CompanyName = B.compa_name 
		FROM UserCompany A  
		LEFT JOIN [dbo].[Company] B
		ON A.company_id = B.id_compa
		WHERE company_id = @UserCompanyId;
        SELECT @PermissionName = name FROM Permission WHERE id_permi = @PermissionId;
        SELECT @EntityName = entit_name FROM EntityCatalog WHERE id_entit = @EntityCatalogId;

        -- Insertar permiso para el usuario
        INSERT INTO PermiUser (usercompany_id, permission_id, entitycatalog_id, peusr_include)
        VALUES (@UserCompanyId, @PermissionId, @EntityCatalogId, @Include);

        -- Establecer mensaje de confirmación
        SET @Message = CONCAT('Permiso "', @PermissionName, '" ha sido asignado al usuario "', @CompanyName, '" en la entidad "', @EntityName, '".');

        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        DECLARE @ErrorMessage NVARCHAR(4000);
        DECLARE @ErrorSeverity INT;
        DECLARE @ErrorState INT;

        SELECT @ErrorMessage = ERROR_MESSAGE(),
               @ErrorSeverity = ERROR_SEVERITY(),
               @ErrorState = ERROR_STATE();

        RAISERROR(@ErrorMessage, @ErrorSeverity, @ErrorState);
    END CATCH
END
GO



/****** Object:  StoredProcedure [dbo].[GetRolePermissions]    Script Date: 3/11/2024 1:54:19 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetRolePermissions]
    @RoleId BIGINT,
    @EntityCatalogId BIGINT
AS
BEGIN
    SET NOCOUNT ON;

    SELECT P.*
    FROM Permission P
    JOIN PermiRole PR ON P.id_permi = PR.permission_id
    WHERE PR.role_id = @RoleId
      AND PR.entitycatalog_id = @EntityCatalogId;
END
GO
/****** Object:  StoredProcedure [dbo].[GetRoleRecordPermissions]    Script Date: 3/11/2024 1:54:19 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetRoleRecordPermissions]
    @RoleId BIGINT,
    @EntityCatalogId BIGINT,
    @RecordId BIGINT
AS
BEGIN
    SET NOCOUNT ON;

    SELECT P.*
    FROM Permission P
    JOIN PermiRoleRecord PRR ON P.id_permi = PRR.permission_id
    WHERE PRR.role_id = @RoleId
      AND PRR.entitycatalog_id = @EntityCatalogId
      AND PRR.perrc_record = @RecordId;
END
GO
/****** Object:  StoredProcedure [dbo].[GetUserPermissions]    Script Date: 3/11/2024 1:54:19 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetUserPermissions]
    @UserCompanyId BIGINT,
    @EntityCatalogId BIGINT
AS
BEGIN
    SET NOCOUNT ON;

    SELECT P.*
    FROM Permission P
    JOIN PermiUser PU ON P.id_permi = PU.permission_id
    WHERE PU.usercompany_id = @UserCompanyId
      AND PU.entitycatalog_id = @EntityCatalogId;
END
GO
/****** Object:  StoredProcedure [dbo].[GetUserRecordPermissions]    Script Date: 3/11/2024 1:54:19 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetUserRecordPermissions]
    @UserCompanyId BIGINT,
    @EntityCatalogId BIGINT,
    @RecordId BIGINT
AS
BEGIN
    SET NOCOUNT ON;

    SELECT P.*
    FROM Permission P
    JOIN PermiUserRecord PUR ON P.id_permi = PUR.permission_id
    WHERE PUR.usercompany_id = @UserCompanyId
      AND PUR.entitycatalog_id = @EntityCatalogId
      AND PUR.peusr_record = @RecordId;
END
GO
/****** Object:  StoredProcedure [dbo].[RemoveRolePermission]    Script Date: 3/11/2024 1:54:19 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[RemoveRolePermission]
    @RoleId BIGINT,
    @PermissionId BIGINT,
    @EntityCatalogId BIGINT
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        BEGIN TRANSACTION;

        -- Validar si el permiso existe
        IF NOT EXISTS (SELECT 1 FROM PermiRole WHERE role_id = @RoleId AND permission_id = @PermissionId AND entitycatalog_id = @EntityCatalogId)
        BEGIN
            RAISERROR('El permiso no está asignado al rol.', 16, 1);
            ROLLBACK TRANSACTION;
            RETURN;
        END

        DELETE FROM PermiRole
        WHERE role_id = @RoleId
          AND permission_id = @PermissionId
          AND entitycatalog_id = @EntityCatalogId;

        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        DECLARE @ErrorMessage NVARCHAR(4000);
        DECLARE @ErrorSeverity INT;
        DECLARE @ErrorState INT;

        SELECT @ErrorMessage = ERROR_MESSAGE(),
               @ErrorSeverity = ERROR_SEVERITY(),
               @ErrorState = ERROR_STATE();

        RAISERROR(@ErrorMessage, @ErrorSeverity, @ErrorState);
    END CATCH
END
GO
/****** Object:  StoredProcedure [dbo].[RemoveUserPermission]    Script Date: 3/11/2024 1:54:19 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[RemoveUserPermission]
    @UserCompanyId BIGINT,
    @PermissionId BIGINT,
    @EntityCatalogId BIGINT
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        BEGIN TRANSACTION;

        -- Validar si el permiso existe
        IF NOT EXISTS (SELECT 1 FROM PermiUser WHERE usercompany_id = @UserCompanyId AND permission_id = @PermissionId AND entitycatalog_id = @EntityCatalogId)
        BEGIN
            RAISERROR('El permiso no está asignado al usuario.', 16, 1);
            ROLLBACK TRANSACTION;
            RETURN;
        END

        DELETE FROM PermiUser
        WHERE usercompany_id = @UserCompanyId
          AND permission_id = @PermissionId
          AND entitycatalog_id = @EntityCatalogId;

        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        DECLARE @ErrorMessage NVARCHAR(4000);
        DECLARE @ErrorSeverity INT;
        DECLARE @ErrorState INT;

        SELECT @ErrorMessage = ERROR_MESSAGE(),
               @ErrorSeverity = ERROR_SEVERITY(),
               @ErrorState = ERROR_STATE();

        RAISERROR(@ErrorMessage, @ErrorSeverity, @ErrorState);
    END CATCH
END
GO
