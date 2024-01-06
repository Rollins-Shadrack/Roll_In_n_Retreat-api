const { PrismaClient } = require('@prisma/client');

const prisma = new PrismaClient();

const emailExist = async (email, prismaInstance) => {
    try {
        const account = await prismaInstance.account.findUnique({ where: { email } });
        if (account && account.id) return { message: 'Email is in use please use a different email or login/ reset your password', activated: true, id: account.id };

        const registration = await prismaInstance.hold.findUnique({ where: { email } });
        if (!registration) return false;
        if (registration && registration.account_status === 'confirmed') return { message: 'Please login or reset your password', activated: true };
        if (registration && registration.account_status === 'pending')
            return { message: 'registration is pending activation please click on the link sent to your email or request a new link', activated: false };
        
    } catch (error) {
        console.error('an error has occured:', error.message);
    } finally {
        await prisma.$disconnect()
    }
}

module.exports = emailExist;