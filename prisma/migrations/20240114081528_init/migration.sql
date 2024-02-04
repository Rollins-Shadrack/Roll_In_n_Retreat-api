/*
  Warnings:

  - A unique constraint covering the columns `[main_service_category_id]` on the table `partner` will be added. If there are existing duplicate values, this will fail.
  - A unique constraint covering the columns `[city_id]` on the table `partner` will be added. If there are existing duplicate values, this will fail.
  - A unique constraint covering the columns `[staff_address_id]` on the table `staff` will be added. If there are existing duplicate values, this will fail.
  - A unique constraint covering the columns `[user_address_id]` on the table `user` will be added. If there are existing duplicate values, this will fail.
  - Added the required column `business_name` to the `partner` table without a default value. This is not possible if the table is not empty.
  - Added the required column `business_type_id` to the `partner` table without a default value. This is not possible if the table is not empty.
  - Added the required column `first_name` to the `partner` table without a default value. This is not possible if the table is not empty.
  - Added the required column `last_name` to the `partner` table without a default value. This is not possible if the table is not empty.
  - Added the required column `main_service_category_id` to the `partner` table without a default value. This is not possible if the table is not empty.
  - Added the required column `membership_type_id` to the `partner` table without a default value. This is not possible if the table is not empty.
  - Added the required column `staff_address_id` to the `staff` table without a default value. This is not possible if the table is not empty.
  - Added the required column `user_address_id` to the `user` table without a default value. This is not possible if the table is not empty.

*/
-- CreateEnum
CREATE TYPE "workingpattern" AS ENUM ('standard', 'rota');

-- CreateEnum
CREATE TYPE "staffrange" AS ENUM ('onetofive', 'fivetoten', 'tentofifteen', 'morethanfifteen');

-- AlterTable
ALTER TABLE "booking" ADD COLUMN     "serviceId" TEXT;

-- AlterTable
ALTER TABLE "partner" ADD COLUMN     "business_name" VARCHAR(255) NOT NULL,
ADD COLUMN     "business_type_id" TEXT NOT NULL,
ADD COLUMN     "city_id" TEXT,
ADD COLUMN     "created_at" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
ADD COLUMN     "deleted_at" DATE,
ADD COLUMN     "first_name" VARCHAR(255) NOT NULL,
ADD COLUMN     "is_marketplace_active" BOOLEAN NOT NULL DEFAULT true,
ADD COLUMN     "last_name" VARCHAR(255) NOT NULL,
ADD COLUMN     "main_service_category_id" TEXT NOT NULL,
ADD COLUMN     "membership_type_id" TEXT NOT NULL,
ADD COLUMN     "mobile_number" VARCHAR(255),
ADD COLUMN     "partner_address_id" TEXT,
ADD COLUMN     "staff_count" "staffrange" NOT NULL DEFAULT 'onetofive',
ADD COLUMN     "suspension_reason_id" TEXT,
ADD COLUMN     "updated_at" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
ADD COLUMN     "working_pattern" "workingpattern" NOT NULL DEFAULT 'standard';

-- AlterTable
ALTER TABLE "staff" ADD COLUMN     "staff_address_id" TEXT NOT NULL;

-- AlterTable
ALTER TABLE "user" ADD COLUMN     "user_address_id" TEXT NOT NULL;

-- CreateTable
CREATE TABLE "addon" (
    "id" TEXT NOT NULL,
    "name" VARCHAR(255),
    "name_unique" VARCHAR(255),
    "price" INTEGER,
    "duration" INTEGER,
    "description" TEXT,
    "partner_id" TEXT NOT NULL,
    "features" JSONB,
    "is_active" BOOLEAN NOT NULL DEFAULT true,
    "data" JSONB,
    "deleted_at" DATE,
    "created_at" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "addon_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "address" (
    "id" TEXT NOT NULL,
    "country" VARCHAR(255),
    "town_city" VARCHAR(255),
    "address_line1" VARCHAR(255),
    "address_line2" VARCHAR(255),
    "address_line3" VARCHAR(255),
    "postal_code" VARCHAR(255),
    "location" JSONB,
    "data" JSONB,
    "deleted_at" DATE,
    "created_at" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "address_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "amenities" (
    "id" TEXT NOT NULL,
    "partner_id" TEXT NOT NULL,
    "amenity" JSONB NOT NULL DEFAULT '{}',
    "data" JSONB,
    "deleted_at" DATE,
    "created_at" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "amenities_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "booking_addon" (
    "id" TEXT NOT NULL,
    "booking_id" TEXT NOT NULL,
    "addon_id" TEXT NOT NULL,
    "addon_name" VARCHAR(255),
    "addon_description" VARCHAR(255),
    "addon_price" INTEGER,
    "addon_duration" INTEGER,
    "data" JSONB,
    "deleted_at" DATE,
    "created_at" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "booking_addon_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "business_hours" (
    "id" TEXT NOT NULL,
    "partner_id" TEXT NOT NULL,
    "business_hours" JSONB,
    "break_time" JSONB,
    "data" JSONB,
    "deleted_at" DATE,
    "created_at" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "effective_date" DATE NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "is_active" BOOLEAN NOT NULL DEFAULT true,

    CONSTRAINT "business_hours_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "booking_rules" (
    "id" TEXT NOT NULL,
    "partner_id" TEXT NOT NULL,
    "deposit" JSONB,
    "online_payment_active" BOOLEAN DEFAULT false,
    "group_booking" JSONB,
    "booking_period" JSONB,
    "cancellation_rules" JSONB,
    "confirmation_rule" JSONB,
    "deleted_at" DATE,
    "data" JSONB,
    "created_at" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "booking_rules_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "business_type" (
    "id" TEXT NOT NULL,
    "name" VARCHAR(255) NOT NULL,
    "name_unique" VARCHAR(255),
    "data" JSONB,
    "deleted_at" DATE,
    "created_at" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "business_type_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "city" (
    "id" TEXT NOT NULL,
    "name" VARCHAR(255) NOT NULL,
    "data" JSONB,
    "deleted_at" DATE,
    "created_at" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "city_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "comment" (
    "id" TEXT NOT NULL,
    "comments" TEXT,
    "staff_id" TEXT NOT NULL,
    "partner_id" TEXT NOT NULL,
    "is_published" BOOLEAN NOT NULL DEFAULT true,
    "disputed" BOOLEAN NOT NULL DEFAULT false,
    "is_verified_by_partner" BOOLEAN NOT NULL DEFAULT false,
    "is_verified_by_staff" BOOLEAN NOT NULL DEFAULT false,
    "is_vetted" BOOLEAN NOT NULL DEFAULT false,
    "is_nominated" BOOLEAN NOT NULL DEFAULT false,
    "rating" INTEGER NOT NULL,
    "booking_id" TEXT NOT NULL,
    "data" JSONB,
    "deleted_at" DATE,
    "created_at" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "comment_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "comment_dispute" (
    "id" TEXT NOT NULL,
    "comment_id" TEXT NOT NULL,
    "partner_id" TEXT NOT NULL,
    "dispute_reason_id" TEXT NOT NULL,
    "resolved" BOOLEAN NOT NULL DEFAULT false,
    "resolution_id" TEXT NOT NULL,
    "data" JSONB,
    "deleted_at" DATE,
    "created_at" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "comment_dispute_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "comment_resolution" (
    "id" TEXT NOT NULL,
    "name" VARCHAR(255),
    "name_unique" VARCHAR(255),
    "data" JSONB,
    "deleted_at" DATE,
    "created_at" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "comment_resolution_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "dispute_reason" (
    "id" TEXT NOT NULL,
    "name" VARCHAR(255),
    "name_unique" VARCHAR(255),
    "data" JSONB,
    "deleted_at" DATE,
    "created_at" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "dispute_reason_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "hotel_addon" (
    "id" TEXT NOT NULL,
    "addon_id" TEXT NOT NULL,
    "hotel_id" TEXT NOT NULL,
    "is_active" BOOLEAN NOT NULL DEFAULT true,
    "deleted_at" DATE,
    "created_at" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "hotel_addon_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "hotel_room" (
    "id" TEXT NOT NULL,
    "room_number" INTEGER NOT NULL,
    "room_type" TEXT NOT NULL,
    "price_per_night" INTEGER NOT NULL,
    "is_available" BOOLEAN NOT NULL DEFAULT true,
    "description" TEXT,
    "amenities" JSONB,
    "hotel_id" TEXT NOT NULL,
    "created_at" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "hotel_room_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "partner_service_category" (
    "id" TEXT NOT NULL,
    "partner_id" TEXT,
    "service_category_id" TEXT,
    "is_main" BOOLEAN DEFAULT false,
    "enabled" BOOLEAN NOT NULL DEFAULT false,
    "data" JSONB,
    "deleted_at" DATE,
    "created_at" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "partner_service_category_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "service" (
    "id" TEXT NOT NULL,
    "name" VARCHAR(255),
    "name_unique" VARCHAR(255),
    "description" TEXT,
    "is_active" BOOLEAN NOT NULL DEFAULT false,
    "activation_date" DATE DEFAULT CURRENT_TIMESTAMP,
    "has_add_on" BOOLEAN DEFAULT false,
    "service_visbility_id" TEXT NOT NULL,
    "confirmation_type_id" TEXT NOT NULL,
    "service_category_id" TEXT NOT NULL,
    "service_internal_category_id" TEXT,
    "partner_id" TEXT NOT NULL,
    "slug" VARCHAR(255),
    "data" JSONB,
    "deleted_at" DATE,
    "created_at" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "service_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "service_addon" (
    "id" TEXT NOT NULL,
    "service_id" TEXT NOT NULL,
    "addon_id" TEXT NOT NULL,
    "is_active" BOOLEAN NOT NULL DEFAULT true,
    "data" JSONB,
    "deleted_at" DATE,
    "created_at" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "service_addon_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "service_category" (
    "id" TEXT NOT NULL,
    "name" VARCHAR(255),
    "name_unique" VARCHAR(255),
    "is_active" BOOLEAN NOT NULL DEFAULT true,
    "data" JSONB,
    "deleted_at" DATE,
    "created_at" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "service_category_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "service_sub_category" (
    "id" TEXT NOT NULL,
    "name" VARCHAR(255),
    "name_unique" VARCHAR(255),
    "service_category_id" TEXT NOT NULL,
    "data" JSONB,
    "deleted_at" DATE,
    "created_at" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "service_sub_category_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "membership_type" (
    "id" TEXT NOT NULL,
    "name" VARCHAR(255) NOT NULL DEFAULT 'base',
    "name_unique" VARCHAR(255),
    "data" JSONB,
    "deleted_at" DATE,
    "created_at" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "membership_type_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE UNIQUE INDEX "addon_partner_id_key" ON "addon"("partner_id");

-- CreateIndex
CREATE UNIQUE INDEX "addon_name_partnerid_unique" ON "addon"("name", "partner_id");

-- CreateIndex
CREATE UNIQUE INDEX "amenities_partnerid_unique" ON "amenities"("partner_id");

-- CreateIndex
CREATE UNIQUE INDEX "businesshours_partnerid_effectivedate_unique" ON "business_hours"("partner_id", "effective_date");

-- CreateIndex
CREATE UNIQUE INDEX "booking_rules_partner_id_key" ON "booking_rules"("partner_id");

-- CreateIndex
CREATE UNIQUE INDEX "business_type_name_unique_key" ON "business_type"("name_unique");

-- CreateIndex
CREATE UNIQUE INDEX "hoteladdon_addonid_hotelid_unique" ON "hotel_addon"("addon_id", "hotel_id");

-- CreateIndex
CREATE UNIQUE INDEX "hotel_room_hotel_id_key" ON "hotel_room"("hotel_id");

-- CreateIndex
CREATE UNIQUE INDEX "hotelroom_roomnumber_hotelid_unique" ON "hotel_room"("room_number", "hotel_id");

-- CreateIndex
CREATE UNIQUE INDEX "partner_service_category_partner_id_key" ON "partner_service_category"("partner_id");

-- CreateIndex
CREATE UNIQUE INDEX "partner_service_category_service_category_id_key" ON "partner_service_category"("service_category_id");

-- CreateIndex
CREATE UNIQUE INDEX "partnerservicecategory_partnerid_servicecategoryid_unique" ON "partner_service_category"("partner_id", "service_category_id");

-- CreateIndex
CREATE UNIQUE INDEX "service_slug_key" ON "service"("slug");

-- CreateIndex
CREATE UNIQUE INDEX "service_name_partnerid_unique" ON "service"("name", "partner_id");

-- CreateIndex
CREATE UNIQUE INDEX "service_addon_service_id_key" ON "service_addon"("service_id");

-- CreateIndex
CREATE UNIQUE INDEX "service_addon_addon_id_key" ON "service_addon"("addon_id");

-- CreateIndex
CREATE UNIQUE INDEX "serviceaddon_serviceid_addonid_unique" ON "service_addon"("service_id", "addon_id");

-- CreateIndex
CREATE UNIQUE INDEX "service_category_name_unique_key" ON "service_category"("name_unique");

-- CreateIndex
CREATE UNIQUE INDEX "service_sub_category_name_unique_key" ON "service_sub_category"("name_unique");

-- CreateIndex
CREATE UNIQUE INDEX "service_sub_category_service_category_id_key" ON "service_sub_category"("service_category_id");

-- CreateIndex
CREATE UNIQUE INDEX "membership_type_name_unique_key" ON "membership_type"("name_unique");

-- CreateIndex
CREATE UNIQUE INDEX "partner_main_service_category_id_key" ON "partner"("main_service_category_id");

-- CreateIndex
CREATE UNIQUE INDEX "partner_city_id_key" ON "partner"("city_id");

-- CreateIndex
CREATE UNIQUE INDEX "staff_staff_address_id_key" ON "staff"("staff_address_id");

-- CreateIndex
CREATE UNIQUE INDEX "user_user_address_id_key" ON "user"("user_address_id");

-- AddForeignKey
ALTER TABLE "addon" ADD CONSTRAINT "addon_partner_id_fkey" FOREIGN KEY ("partner_id") REFERENCES "partner"("id") ON DELETE NO ACTION ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE "amenities" ADD CONSTRAINT "amenities_partner_id_fkey" FOREIGN KEY ("partner_id") REFERENCES "partner"("id") ON DELETE NO ACTION ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE "booking" ADD CONSTRAINT "booking_partner_id_fkey" FOREIGN KEY ("partner_id") REFERENCES "partner"("id") ON DELETE NO ACTION ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE "booking" ADD CONSTRAINT "booking_serviceId_fkey" FOREIGN KEY ("serviceId") REFERENCES "service"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "booking_addon" ADD CONSTRAINT "booking_addon_addon_id_fkey" FOREIGN KEY ("addon_id") REFERENCES "addon"("id") ON DELETE NO ACTION ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE "booking_addon" ADD CONSTRAINT "booking_addon_booking_id_fkey" FOREIGN KEY ("booking_id") REFERENCES "booking"("id") ON DELETE NO ACTION ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE "business_hours" ADD CONSTRAINT "business_hours_partner_id_fkey" FOREIGN KEY ("partner_id") REFERENCES "partner"("id") ON DELETE NO ACTION ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE "booking_rules" ADD CONSTRAINT "booking_rules_partner_id_fkey" FOREIGN KEY ("partner_id") REFERENCES "partner"("id") ON DELETE NO ACTION ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE "comment" ADD CONSTRAINT "comment_booking_id_fkey" FOREIGN KEY ("booking_id") REFERENCES "booking"("id") ON DELETE NO ACTION ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE "comment" ADD CONSTRAINT "comment_partner_id_fkey" FOREIGN KEY ("partner_id") REFERENCES "partner"("id") ON DELETE NO ACTION ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE "comment" ADD CONSTRAINT "comment_staff_id_fkey" FOREIGN KEY ("staff_id") REFERENCES "staff"("id") ON DELETE NO ACTION ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE "comment_dispute" ADD CONSTRAINT "comment_dispute_comment_id_fkey" FOREIGN KEY ("comment_id") REFERENCES "comment"("id") ON DELETE NO ACTION ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE "comment_dispute" ADD CONSTRAINT "comment_dispute_dispute_reason_id_fkey" FOREIGN KEY ("dispute_reason_id") REFERENCES "dispute_reason"("id") ON DELETE NO ACTION ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE "comment_dispute" ADD CONSTRAINT "comment_dispute_partner_id_fkey" FOREIGN KEY ("partner_id") REFERENCES "partner"("id") ON DELETE NO ACTION ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE "comment_dispute" ADD CONSTRAINT "comment_dispute_resolution_id_fkey" FOREIGN KEY ("resolution_id") REFERENCES "comment_resolution"("id") ON DELETE NO ACTION ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE "hotel_addon" ADD CONSTRAINT "hotel_addon_addon_id_fkey" FOREIGN KEY ("addon_id") REFERENCES "addon"("id") ON DELETE NO ACTION ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE "hotel_addon" ADD CONSTRAINT "hotel_addon_hotel_id_fkey" FOREIGN KEY ("hotel_id") REFERENCES "partner"("id") ON DELETE NO ACTION ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE "hotel_room" ADD CONSTRAINT "hotel_room_hotel_id_fkey" FOREIGN KEY ("hotel_id") REFERENCES "partner"("id") ON DELETE NO ACTION ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE "partner" ADD CONSTRAINT "partner_business_type_id_fkey" FOREIGN KEY ("business_type_id") REFERENCES "business_type"("id") ON DELETE NO ACTION ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE "partner" ADD CONSTRAINT "partner_membership_type_id_fkey" FOREIGN KEY ("membership_type_id") REFERENCES "membership_type"("id") ON DELETE NO ACTION ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE "partner" ADD CONSTRAINT "partner_partner_address_id_fkey" FOREIGN KEY ("partner_address_id") REFERENCES "address"("id") ON DELETE NO ACTION ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE "partner" ADD CONSTRAINT "partner_main_service_category_id_fkey" FOREIGN KEY ("main_service_category_id") REFERENCES "service_category"("id") ON DELETE NO ACTION ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE "partner" ADD CONSTRAINT "partner_city_id_fkey" FOREIGN KEY ("city_id") REFERENCES "city"("id") ON DELETE NO ACTION ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE "partner_service_category" ADD CONSTRAINT "partner_service_category_partner_id_fkey" FOREIGN KEY ("partner_id") REFERENCES "partner"("id") ON DELETE NO ACTION ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE "partner_service_category" ADD CONSTRAINT "partner_service_category_service_category_id_fkey" FOREIGN KEY ("service_category_id") REFERENCES "service_category"("id") ON DELETE NO ACTION ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE "service" ADD CONSTRAINT "service_partner_id_fkey" FOREIGN KEY ("partner_id") REFERENCES "partner"("id") ON DELETE NO ACTION ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE "service" ADD CONSTRAINT "service_service_category_id_fkey" FOREIGN KEY ("service_category_id") REFERENCES "service_category"("id") ON DELETE NO ACTION ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE "service_addon" ADD CONSTRAINT "service_addon_addon_id_fkey" FOREIGN KEY ("addon_id") REFERENCES "addon"("id") ON DELETE NO ACTION ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE "service_addon" ADD CONSTRAINT "service_addon_service_id_fkey" FOREIGN KEY ("service_id") REFERENCES "service"("id") ON DELETE NO ACTION ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE "service_sub_category" ADD CONSTRAINT "service_sub_category_service_category_id_fkey" FOREIGN KEY ("service_category_id") REFERENCES "service_category"("id") ON DELETE NO ACTION ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE "staff" ADD CONSTRAINT "staff_staff_address_id_fkey" FOREIGN KEY ("staff_address_id") REFERENCES "address"("id") ON DELETE NO ACTION ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE "user" ADD CONSTRAINT "user_user_address_id_fkey" FOREIGN KEY ("user_address_id") REFERENCES "address"("id") ON DELETE NO ACTION ON UPDATE NO ACTION;
