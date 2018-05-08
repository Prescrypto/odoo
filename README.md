# Odoo

## Ambiente de desarrollo

1. Instalar [Docker for Mac][docker].

2. Inicializar el ambiente de desarrollo.

    ```sh
    # descargar codigo fuente
    git clone git@github.com:Prescrypto/odoo.git --recursive

    # ir al directorio del proyecto
    cd odoo

    # crear ambiente de desarrollo
    docker-compose up -d

    # abrir terminal de la aplicación
    docker attach odoo_web_1

    # correr servidor
    cd /mnt/prescrypto-odoo
    ./odoo-bin -r odoo -w odoo --db_host db --addons-path=addons,prescrypto -i campos_clientes_vittal
    ```

3. Abrir http://localhost:8069/ en su navegador.

## Operaciones comunes

**Recargar el módulo**

Esto es necesario al actualizar el modelo ya que se ocupan recompilar la fuente Python.

```sh
./odoo-bin -r odoo -w odoo --db_host db --addons-path=addons,prescrypto -u campos_clientes_vittal
```

**Detener el servidor**

```sh
docker-compose down
```

## Herramientas adicionales

### Gestión gráfica de PostgreSQL

[pgAdmin 4][pgadmin] viene incluido para administrar la base de datos local. Se puede encontrar en  http://localhost:5050/. Los valores para conectarse a la base de datos de la instalación de Odoo son los siguientes:

- **Host name/address**: db

- **Username**: odoo

- **Password**: odoo

### Gestión gráfica de Docker

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


### For custom modules

Get clone the custom modules on `./prescrypto/` for example:
* `$ cd ./odoo/Prescrypto/`
* `./odoo/Prescrypto/ $ git clone https://github.com/Prescrypto/campos-clientes-vittal`
* `./odoo/Prescrypto/ $ cd campos-clientes-vittal`
* Maybe here you need to switch to some branch or create new one then

You are ready to development with our custom odoo and our custom modules
