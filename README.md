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
