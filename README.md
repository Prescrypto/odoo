# Inicio

1. Instalar [Docker for Mac][docker].

2. Inicializar el ambiente de desarrollo.

    ```sh
    # descargar codigo fuente
    git clone git@github.com:Prescrypto/odoo.git && cd oodo

    # crear ambiente de desarrollo
    docker-compose up -d
    ```

3. Abrir http://localhost:8069/ en su navegador.

# Operaciones comunes

**Detener el servidor**

```sh
docker-compose down
```

**Visualizar historial**

```sh
docker-compose logs
```

**Recrear contenedor**

```sh
# cambiar x.x con la versión nueva
docker build -t prescrypto/odoo:x.x -t prescrypto/odoo:latest .
```

**Actualizar contenedor**

```sh
# autenticar con hub.docker.com
docker login

# subir versión nueva a hub.docker.com
docker push prescrypto/odoo
```

# Herramientas adicionales

## Gestión gráfica de PostgreSQL

[pgAdmin 4][pgadmin] viene incluido para administrar la base de datos local. Se puede encontrar en  http://localhost:5050/. Los valores para conectarse a la base de datos de la instalación de Odoo son los siguientes:

- **Host name/address**: db

- **Username**: odoo

- **Password**: odoo

## Gestión gráfica de Docker

Docker es una herramienta poderosa, pero complicada. El uso de un ambiente gráfico ayudara a diagnosticar y a entender el ambiente Docker de una manera sencilla. En este caso, utilizaremos [Portainer][portainer].

1. Abrir una terminal.

2. Descargar la imagen.

    ```sh
    docker pull portainer/portainer
    ```

3. Correr la aplicación.

    ```sh
    docker run -d -p 9000:9000 -v /var/run/docker.sock:/var/run/docker.sock portainer/portainer
    ```

4. Abrir http://localhost:9000/ en un navegador.

5. Seguir las indicaciones.

[docker]: https://docs.docker.com/docker-for-mac/install/#what-to-know-before-you-install
[portainer]: https://portainer.io/
[pgadmin]: https://www.pgadmin.org/
