
# Login with phone using otp msg using Twilio service.

## Dependencies
<div style="display:flex; align-items:center;">
    <h3>Docker PostgreSQL</h2>
    <img src="https://static-00.iconduck.com/assets.00/postgresql-icon-1987x2048-v2fkmdaw.png" alt="Texto alternativo" width="25" style="margin-left: 2px;">
</div>

```
docker pull postgres
```
```bash
docker run -d --name <cont-name> -p 5432:5432 -e POSTGRES_PASSWORD=<password> postgres
```

### Verify your docker container
```bash
docker ps
```

## Start Server
```bash
cd login_msg_otp_server/
```

```bash
yarn start:dev
```
## Demo
#### [Watch Demo](https://www.youtube.com/shorts/hGB-URFCB3E)

<iframe width="560" height="315" src="https://www.youtube.com/embed/hGB-URFCB3E" frameborder="1" allowfullscreen></iframe>


<div style="text-align:center;">
    <video width="320" height="240" controls>
        <source src="https://www.youtube.com/shorts/hGB-URFCB3E" type="video/mp4">
        Your browser does not support the video tag.
    </video>
</div>