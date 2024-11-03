# Stone_ERP Permission Management System  

  

## Descripción  

  

El sistema de gestión de permisos de Stone_ERP permite asignar y gestionar permisos a usuarios y roles a nivel de entidad y registro individual. Este sistema está diseñado para manejar entidades como `Sucursal` y `Centro de Costos`, facilitando la administración de acceso a la información crítica dentro de la base de datos.  


Para el correcto despliegue del proyecto se debe crear una base de datos llamada Stone_ERP, en la cual se debe desplegar las tablas que se encuentran en el archivo `scripts_para_crear_tablas.sql` en la carpeta del mismo nombre; adicionalmente se debe desplegar los procedimientos almacenados del archivo `scripts_procedimientos_almacenados.sql` y de carpeta del mismo nombre; lo anterior dando F5 a los script en SQL Server.
  

## Funcionalidades  

  

- **Gestión de Usuarios**: Creación, modificación y eliminación de usuarios.  

- **Gestión de Roles**: Definición y gestión de roles con permisos asociados.  

- **Asignación de Permisos**: Permite asignar permisos a usuarios y roles a nivel de entidad y registro individual.  

- **Auditoría de Permisos**: Registro de actividades relacionadas con permisos a través de SQL Server Audit.  

  

## Tablas  

  

La base de datos Stone_ERP incluye las siguientes tablas relevantes para la gestión de permisos:  

  

- **BranchOffice**: Información sobre sucursales.  

- **Company**: Detalles de las compañías.  

- **CostCenter**: Información sobre centros de costos.  

- **EntityCatalog**: Catálogo de entidades.  

- **PermiRole**: Definición de roles y sus permisos.  

- **PermiRoleRecord**: Registro de permisos asociados a roles.  

- **PermiUser**: Información sobre usuarios y sus permisos.  

- **PermiUserRecord**: Registro de permisos asociados a usuarios.  

- **Permission**: Detalles de los permisos disponibles.  

- **Role**: Definición de roles en el sistema.  

- **User**: Información de los usuarios.  

  

## Procedimientos Almacenados  

  

La base de datos Stone_ERP incluye los siguientes procedimientos almacenados relevantes para la gestión:  

  

1. **AssignRolePermission**:  

   Asigna un permiso específico a un rol dentro de una entidad, validando primero la existencia del rol, el permiso y la entidad.  

    CREATE PROCEDURE [dbo].[AssignRolePermission]  

       @RoleId BIGINT,  

       @PermissionId BIGINT,  

       @EntityCatalogId BIGINT,  

       @Include BIT

   

2. ** AssignUserPermission**:  

Asigna un permiso específico a un usuario en el contexto de una entidad, asegurando que tanto el usuario como el permiso y la entidad existan. 

CREATE PROCEDURE [dbo].[AssignUserPermission]  

    @UserCompanyId BIGINT,  

    @PermissionId BIGINT,  

    @EntityCatalogId BIGINT,  

    @Include BIT

  

```3. ** GetRolePermissions**: 

 Recupera todos los permisos asociados a un rol en una entidad específica, proporcionando una vista de los accesos concedidos al rol. 

CREATE PROCEDURE [dbo].[GetRolePermissions]  

    @RoleId BIGINT,  

    @EntityCatalogId BIGINT  

 

 

4. ** GetRoleRecordPermissions**: 

 Obtiene permisos específicos de un rol para un registro particular dentro de una entidad, permitiendo gestionar el acceso a nivel granular. 

CREATE PROCEDURE [dbo].[GetRoleRecordPermissions]  

    @RoleId BIGINT,  

    @EntityCatalogId BIGINT,  

    @RecordId BIGINT  

5. ** GetUserPermissions**:  

Recupera todos los permisos asociados a un usuario en una entidad específica, lo que ayuda a entender el acceso total que tiene el usuario. 

CREATE PROCEDURE [dbo].[GetUserPermissions]  

    @UserCompanyId BIGINT,  

    @EntityCatalogId BIGINT



6. ** GetUserRecordPermissions**: 

 Obtiene permisos específicos de un usuario para un registro determinado en una entidad, facilitando la administración de permisos a nivel de registro. 

CREATE PROCEDURE [dbo].[GetUserRecordPermissions]  

    @UserCompanyId BIGINT,  

    @EntityCatalogId BIGINT,  

    @RecordId BIGINT



7. ** RemoveRolePermission**:
Elimina un permiso asignado a un rol en una entidad específica, garantizando que el permiso esté efectivamente asignado antes de la eliminación. 

CREATE PROCEDURE [dbo].[RemoveRolePermission]  

    @RoleId BIGINT,  

    @PermissionId BIGINT,  

    @EntityCatalogId BIGINT  

 

 

8. ** RemoveUserPermission**: 

 Elimina un permiso asignado a un usuario en una entidad específica, asegurando que el permiso esté asociado al usuario antes de proceder con la eliminación. 

CREATE PROCEDURE [dbo].[RemoveUserPermission]  

    @UserCompanyId BIGINT,  

    @PermissionId BIGINT,  

    @EntityCatalogId BIGINT



## Datos utilizados para las pruebas:

-- Datos de prueba para la tabla Company
INSERT INTO [dbo].[Company] (compa_name, compa_tradename, compa_doctype, compa_docnum, compa_address, compa_city, compa_state, compa_country, compa_industry, compa_phone, compa_email, compa_website, compa_active)
VALUES 
('Tech Solutions', 'TechSol', 'NI', '123456789', '123 Tech St', 'Tech City', 'Tech State', 'Techland', 'Information Technology', '555-1234', 'info@techsol.com', 'www.techsol.com', 1),
('Green Gardens', 'GreenG', 'NI', '987654321', '456 Garden Ave', 'Garden City', 'Garden State', 'Gardenland', 'Agriculture', '555-5678', 'info@greengardens.com', NULL, 1);

-- Datos de prueba para la tabla BranchOffice
INSERT INTO [dbo].[BranchOffice] (company_id, broff_name, broff_code, broff_address, broff_city, broff_state, broff_country, broff_phone, broff_email, broff_active)
VALUES 
(4, 'Tech Solutions HQ', 'TS-HQ', '789 Corporate Blvd', 'Tech City', 'Tech State', 'Techland', '555-0001', 'hq@techsol.com', 1),
(5, 'Green Gardens North', 'GG-N', '321 North St', 'Garden City', 'Garden State', 'Gardenland', '555-1111', 'north@greengardens.com', 1);

-- Datos de prueba para la tabla CostCenter
INSERT INTO [dbo].[CostCenter] (company_id, cosce_parent_id, cosce_code, cosce_name, cosce_description, cosce_budget, cosce_level, cosce_active)
VALUES 
(4, NULL, 'CC-IT', 'IT Department', 'Handles all IT-related tasks', 100000.00, 1, 1),
(4, NULL, 'CC-MKT', 'Marketing Department', 'Handles all marketing tasks', 50000.00, 1, 1),
(5, NULL, 'CC-GRD', 'Garden Department', 'Handles garden operations', 75000.00, 1, 1);


-- Datos de prueba para la tabla EntityCatalog
INSERT INTO [dbo].[EntityCatalog] (entit_name, entit_descrip, entit_active, entit_config)
VALUES 
('Sucursal', 'Sucursal de la compañía', 1, NULL),
('Centro de Costos', 'Centro de costos para la gestión de gastos', 1, NULL);



-- Datos de prueba para la tabla PermiRole
INSERT INTO [dbo].[PermiRole] (role_id, permission_id, entitycatalog_id, perol_include, perol_record)
VALUES 
(3, 1, 1, 1, NULL),  -- Rol Admin puede crear sucursales en la entidad Sucursal
(3, 2, 1, 1, NULL),  -- Rol Admin puede leer sucursales en la entidad Sucursal
(4, 2, 1, 1, NULL),  -- Rol User puede leer sucursales en la entidad Sucursal
(4, 3, 1, 0, NULL),  -- Rol User no puede actualizar sucursales en la entidad Sucursal
(4, 4, 2, 1, NULL);  -- Rol User puede leer centros de costos en la entidad Centro de Costos


INSERT INTO PermiRoleRecord (role_id, permission_id, entitycatalog_id, perrc_record, perrc_include)
VALUES 
(3, 1, 1, 101, 1),  -- Rol Admin puede crear registro 101 en Sucursal (activo)
(3, 2, 1, 102, 1),  -- Rol Admin puede leer registro 102 en Sucursal (activo)
(4, 2, 1, 103, 1),  -- Rol User puede leer registro 103 en Sucursal (activo)
(4, 3, 2, 201, 0),  -- Rol User no tiene permiso para actualizar registro 201 en Centro de Costos (inactivo)
(4, 4, 2, 202, 1);  -- Rol User puede leer registro 202 en Centro de Costos (activo)

-- Datos de prueba para la tabla User
INSERT INTO [dbo].[User] (user_username, user_password, user_email, user_phone, user_is_admin, user_is_active)
VALUES 
('techadmin', 'securepassword', 'admin@techsol.com', '555-2222', 1, 1),
('gardenuser', 'securepassword', 'user@greengardens.com', '555-3333', 0, 1);

-- Datos de prueba para la tabla Role
INSERT INTO [dbo].[Role] (company_id, role_name, role_code, role_description, role_active)
VALUES 
(4, 'Admin', 'ROLE-ADMIN', 'Administrator role with full access', 1),
(5, 'User', 'ROLE-USER', 'User role with limited access', 1);

-- Datos de prueba para la tabla Permission
INSERT INTO [dbo].[Permission] (name, description, can_create, can_read, can_update, can_delete, can_import, can_export)
VALUES 
('Create Branch', 'Allows creating a new branch', 1, 0, 0, 0, 0, 0),
('Read Branch', 'Allows reading branch details', 0, 1, 0, 0, 0, 0),
('Update Branch', 'Allows updating branch information', 0, 0, 1, 0, 0, 0),
('Delete Branch', 'Allows deleting a branch', 0, 0, 0, 1, 0, 0);

-- Datos de prueba para la tabla PermiUser
INSERT INTO [dbo].[PermiUser] (usercompany_id, permission_id, entitycatalog_id, peusr_include)
VALUES 
(4, 1, 1, 1),  -- Usuario en la compañía Tech Solutions tiene permiso para crear sucursales
(4, 2, 1, 1),  -- Usuario en la compañía Tech Solutions tiene permiso para leer sucursales
(5, 2, 1, 1),  -- Usuario en la compañía Green Gardens tiene permiso para leer sucursales
(5, 4, 2, 1),  -- Usuario en la compañía Green Gardens tiene permiso para leer centros de costos
(4, 3, 1, 0),  -- Usuario en la compañía Tech Solutions no tiene permiso para actualizar sucursales
(4, 4, 2, 0);  -- Usuario en la compañía Tech Solutions no tiene permiso para eliminar centros de costos


-- Datos de prueba para la tabla PermiUserRecord
INSERT INTO [dbo].[PermiUserRecord] (usercompany_id, permission_id, entitycatalog_id, peusr_record, peusr_include)
VALUES 
(4, 1, 1, 101, 1),  -- Usuario de Tech Solutions puede crear la sucursal con registro 101
(4, 2, 1, 102, 1),  -- Usuario de Tech Solutions puede leer la sucursal con registro 102
(5, 2, 1, 103, 1),  -- Usuario de Green Gardens puede leer la sucursal con registro 103
(5, 4, 2, 202, 1),  -- Usuario de Green Gardens puede leer el centro de costos con registro 202
(4, 3, 1, 101, 0),  -- Usuario de Tech Solutions no tiene permiso para actualizar la sucursal con registro 101
(4, 4, 2, 201, 0);  -- Usuario de Tech Solutions no tiene permiso para eliminar el centro de costos con registro 201


-- Datos de prueba para la tabla UserCompany
INSERT INTO [dbo].[UserCompany] (user_id, company_id, useco_active)
VALUES 
(1, 4, 1),
(2, 5, 1);
