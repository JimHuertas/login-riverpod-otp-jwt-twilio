
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


https://github.com/JimHuertas/login-riverpod-otp-jwt-twilio/assets/16847578/a41323ca-ff9e-4062-8e3e-594685583681

