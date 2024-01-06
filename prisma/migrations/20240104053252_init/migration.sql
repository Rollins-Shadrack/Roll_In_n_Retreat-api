-- CreateEnum
CREATE TYPE "accounttype" AS ENUM ('staff', 'partner', 'user', 'superadmin');

-- CreateEnum
CREATE TYPE "entitytype" AS ENUM ('staff', 'partner', 'user', 'superadmin');

-- CreateEnum
CREATE TYPE "accountstatus" AS ENUM ('pending', 'deleted', 'confirmed', 'suspended');

-- CreateTable
CREATE TABLE "hold" (
    "id" TEXT NOT NULL,
    "email" VARCHAR(255) NOT NULL,
    "token" JSONB NOT NULL,
    "entity" "accounttype",
    "registration_id" TEXT NOT NULL,
    "process_complete" BOOLEAN NOT NULL DEFAULT false,
    "account_data" JSONB NOT NULL,
    "account_status" "accountstatus" NOT NULL DEFAULT 'pending',
    "registration_date" DATE,
    "expiration_date" DATE,
    "deleted_at" DATE,
    "created_at" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "hold_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "account" (
    "id" TEXT NOT NULL,
    "email" VARCHAR(255) NOT NULL,
    "password" VARCHAR(255) NOT NULL,
    "is_social_login" BOOLEAN NOT NULL DEFAULT false,
    "is_active" BOOLEAN NOT NULL DEFAULT false,
    "is_verified" BOOLEAN NOT NULL DEFAULT false,
    "account_type_id" TEXT NOT NULL,
    "deleted_at" DATE,
    "created_at" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "account_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "sign_up" (
    "id" TEXT NOT NULL,
    "account_id" TEXT,
    "holding_id" TEXT,
    "process_completed" BOOLEAN NOT NULL DEFAULT false,
    "sign_up_agent" JSONB,
    "email" VARCHAR(255) NOT NULL,
    "confirmation_agent" JSONB,
    "completion_agent" JSONB,
    "account_is_active" BOOLEAN NOT NULL DEFAULT false,
    "sign_up_ip_address" VARCHAR(255),
    "confirmation_ip_address" VARCHAR(255),
    "completion_ip_address" VARCHAR(255),
    "deleted_at" DATE,
    "created_at" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "sign_up_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "user" (
    "id" TEXT NOT NULL,
    "first_name" VARCHAR(255) NOT NULL,
    "last_name" VARCHAR(255) NOT NULL,
    "gender" TEXT NOT NULL,
    "mobile_number" VARCHAR(255) NOT NULL,
    "user_role_id" TEXT NOT NULL,
    "user_address" TEXT,
    "entity_type" VARCHAR(255) NOT NULL DEFAULT 'user',
    "deleted_at" DATE,
    "created_at" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "account_id" TEXT NOT NULL,

    CONSTRAINT "user_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "partner" (
    "id" TEXT NOT NULL,
    "account_id" TEXT NOT NULL,

    CONSTRAINT "partner_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "staff" (
    "id" TEXT NOT NULL,
    "account_id" TEXT NOT NULL,

    CONSTRAINT "staff_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "user_profile" (
    "id" TEXT NOT NULL,
    "address" JSONB,
    "location" JSONB,
    "profile_image" VARCHAR(255),
    "communication_preference" JSONB,
    "favourite_hotel" JSONB,
    "deleted_at" DATE,
    "created_at" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "user_id" TEXT NOT NULL,
    "preference_id" TEXT,

    CONSTRAINT "user_profile_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "booking" (
    "id" TEXT NOT NULL,
    "booking_date" DATE NOT NULL,
    "start_date" TIMESTAMPTZ(6) NOT NULL,
    "end_date" TIMESTAMPTZ(6) NOT NULL,
    "duration" INTEGER,
    "entity_type" VARCHAR(255) NOT NULL DEFAULT 'user',
    "partner_id" TEXT NOT NULL,
    "user_id" TEXT NOT NULL,
    "room_id" TEXT NOT NULL,
    "booking_comment" VARCHAR(255),
    "addon_id" TEXT[],
    "deleted_at" DATE,
    "created_at" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "booking_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "preference" (
    "id" TEXT NOT NULL,
    "entity_type" "entitytype",
    "in_app" JSONB NOT NULL,
    "web" JSONB NOT NULL,
    "email" JSONB NOT NULL,
    "sms" JSONB NOT NULL,
    "post" JSONB NOT NULL,
    "data" JSONB,
    "deleted_at" DATE,
    "created_at" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "preference_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE UNIQUE INDEX "hold _email_unique" ON "hold"("email");

-- CreateIndex
CREATE UNIQUE INDEX "hold_registration_id_key" ON "hold"("registration_id");

-- CreateIndex
CREATE UNIQUE INDEX "account_email_unique" ON "account"("email");

-- CreateIndex
CREATE UNIQUE INDEX "sign_up_account_id_key" ON "sign_up"("account_id");

-- CreateIndex
CREATE UNIQUE INDEX "sign_up_holding_id_key" ON "sign_up"("holding_id");

-- CreateIndex
CREATE UNIQUE INDEX "sign_up_email_key" ON "sign_up"("email");

-- CreateIndex
CREATE UNIQUE INDEX "user_user_role_id_key" ON "user"("user_role_id");

-- CreateIndex
CREATE UNIQUE INDEX "user_user_address_key" ON "user"("user_address");

-- CreateIndex
CREATE UNIQUE INDEX "user_account_id_key" ON "user"("account_id");

-- CreateIndex
CREATE UNIQUE INDEX "partner_account_id_key" ON "partner"("account_id");

-- CreateIndex
CREATE UNIQUE INDEX "staff_account_id_key" ON "staff"("account_id");

-- CreateIndex
CREATE UNIQUE INDEX "user_profile_user_id_key" ON "user_profile"("user_id");

-- CreateIndex
CREATE UNIQUE INDEX "user_profile_preference_id_key" ON "user_profile"("preference_id");

-- CreateIndex
CREATE UNIQUE INDEX "booking_partner_id_key" ON "booking"("partner_id");

-- CreateIndex
CREATE UNIQUE INDEX "booking_user_id_key" ON "booking"("user_id");

-- CreateIndex
CREATE UNIQUE INDEX "booking_room_id_key" ON "booking"("room_id");

-- CreateIndex
CREATE UNIQUE INDEX "booking_addon_id_key" ON "booking"("addon_id");

-- AddForeignKey
ALTER TABLE "sign_up" ADD CONSTRAINT "sign_up_account_id_fkey" FOREIGN KEY ("account_id") REFERENCES "account"("id") ON DELETE NO ACTION ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE "sign_up" ADD CONSTRAINT "sign_up_holding_id_fkey" FOREIGN KEY ("holding_id") REFERENCES "hold"("id") ON DELETE CASCADE ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE "user" ADD CONSTRAINT "user_account_id_fkey" FOREIGN KEY ("account_id") REFERENCES "account"("id") ON DELETE NO ACTION ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE "partner" ADD CONSTRAINT "partner_account_id_fkey" FOREIGN KEY ("account_id") REFERENCES "account"("id") ON DELETE NO ACTION ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE "staff" ADD CONSTRAINT "staff_account_id_fkey" FOREIGN KEY ("account_id") REFERENCES "account"("id") ON DELETE NO ACTION ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE "user_profile" ADD CONSTRAINT "user_profile_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "user"("id") ON DELETE NO ACTION ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE "user_profile" ADD CONSTRAINT "user_profile_preference_id_fkey" FOREIGN KEY ("preference_id") REFERENCES "preference"("id") ON DELETE NO ACTION ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE "booking" ADD CONSTRAINT "booking_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "user"("id") ON DELETE RESTRICT ON UPDATE CASCADE;
