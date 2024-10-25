# My Basic Minecraft Server Setup
This repo is for documenting my build process for setting up minecraft using Docker (and mainly using Paper).

This setup was initially made with Minecraft version 1.21

**Environment Requirements**
- Linux CLI (been using bash)
- Docker installed (version 27.3.1 at time of writing)

**Setup Goals**
My intention for the setup is to be relatively minimal yet flexible so can be easily
used in newer versions.
Therefore elements such as .jar files are omitted.

The latest setup also has involved setting up usage for dynmap and voice chat, and
so there default ports are set to be exposed by the docker container if so enabled
(along with rcon).

This setup has also been used as a learning exercise in Docker, so the README will
document notable (to me) commands to use for setting up and managing the created server.

**Creating the Server**
First you must have the required files under the "./server_files" directory.
Most notably required is a "server.jar" which must be the server jar to run.

Create a docker image via `build`, provide a tag with `-t` like so
```bash
docker build -t <image name> .
```
View created images with the command `docker image ls`

Create and then start a container (actual server to run with) with a command such as the following while in the repository;
```bash
docker create -p 25565:25565 <container name> --name=<container name> <image name>
docker start <container name>
```
In the above example, only one port is expose (via the `-p` argument).
If looking to change the port for the minecraft server, change the first of the two
values.
In the container's context the port will still be 25565, but on the actual machine
the selected port is what it will be actually be listening on.

You can shutdown the server via `docker stop <container name>`.
Then start it back up again using `docker start <container name>`.

If you want an interactive bash shell in the container, while it is active
use a command of the form `docker exec -it <container name> bash`.
This is useful if you wish to use the CLI to navigate around the container's files.
