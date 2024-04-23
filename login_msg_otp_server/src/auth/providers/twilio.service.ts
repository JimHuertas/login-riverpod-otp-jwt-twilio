import { BadRequestException, InternalServerErrorException } from "@nestjs/common";
import { Twilio } from "twilio";
export class TwilioService{
    constructor(private readonly twilio = new Twilio(
        process.env.ACCOUNT_SID, 
        process.env.AUTH_TOKEN)
    ) {}   

    async sendMSM(phone: number, tokenNumber: number){
        const messagingServiceSid = process.env.MESSAGING_SERVICE_SID;

        await this.twilio.messages.create({
            body: `VetPet - Tu código de verificación es: ${tokenNumber}, tienes 60 segundos para ingresarlo. No compartas este código con nadie 🤫`,
            messagingServiceSid: messagingServiceSid,
            to: `+51${phone}`
        }).then((unk) =>{
            if (unk.status === "accepted")
                return "Message send successfully";
            return "Message send but ocurre something";
        }).catch((e)=>{
            throw new BadRequestException(e);
        })
    }
}