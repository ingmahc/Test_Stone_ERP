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

        -- Validar si el rol existe
        IF NOT EXISTS (SELECT 1 FROM Role WHERE id_role = @RoleId)
        BEGIN
            RAISERROR('El rol no existe.', 16, 1);
            ROLLBACK TRANSACTION;
            RETURN;
        END

        -- Validar si el permiso existe
        IF NOT EXISTS (SELECT 1 FROM Permission WHERE id_permi = @PermissionId)
        BEGIN
            RAISERROR('El permiso no existe.', 16, 1);
            ROLLBACK TRANSACTION;
            RETURN;
        END

        -- Validar si la entidad existe
        IF NOT EXISTS (SELECT 1 FROM EntityCatalog WHERE id_entit = @EntityCatalogId)
        BEGIN
            RAISERROR('La entidad no existe.', 16, 1);
            ROLLBACK TRANSACTION;
            RETURN;
        END

        INSERT INTO PermiRole (role_id, permission_id, entitycatalog_id, perol_include)
        VALUES (@RoleId, @PermissionId, @EntityCatalogId, @Include);

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
    @Include BIT
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        BEGIN TRANSACTION;

        -- Validar si el usuario existe
        IF NOT EXISTS (SELECT 1 FROM UserCompany WHERE company_id = @UserCompanyId)
        BEGIN
            RAISERROR('El usuario no existe.', 16, 1);
            ROLLBACK TRANSACTION;
            RETURN;
        END

        -- Validar si el permiso existe
        IF NOT EXISTS (SELECT 1 FROM Permission WHERE id_permi = @PermissionId)
        BEGIN
            RAISERROR('El permiso no existe.', 16, 1);
            ROLLBACK TRANSACTION;
            RETURN;
        END

        -- Validar si la entidad existe
        IF NOT EXISTS (SELECT 1 FROM EntityCatalog WHERE id_entit = @EntityCatalogId)
        BEGIN
            RAISERROR('La entidad no existe.', 16, 1);
            ROLLBACK TRANSACTION;
            RETURN;
        END

        INSERT INTO PermiUser (usercompany_id, permission_id, entitycatalog_id, peusr_include)
        VALUES (@UserCompanyId, @PermissionId, @EntityCatalogId, @Include);

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
