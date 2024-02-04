/*
  Warnings:

  - A unique constraint covering the columns `[partner_id]` on the table `staff` will be added. If there are existing duplicate values, this will fail.
  - Added the required column `email` to the `staff` table without a default value. This is not possible if the table is not empty.
  - Added the required column `first_name` to the `staff` table without a default value. This is not possible if the table is not empty.
  - Added the required column `last_name` to the `staff` table without a default value. This is not possible if the table is not empty.
  - Added the required column `partner_id` to the `staff` table without a default value. This is not possible if the table is not empty.

*/
-- AlterTable
ALTER TABLE "partner" ALTER COLUMN "main_service_category_id" DROP NOT NULL,
ALTER COLUMN "membership_type_id" DROP NOT NULL;

-- AlterTable
ALTER TABLE "staff" ADD COLUMN     "email" VARCHAR(255) NOT NULL,
ADD COLUMN     "first_name" VARCHAR(255) NOT NULL,
ADD COLUMN     "is_supper_admin" BOOLEAN NOT NULL DEFAULT false,
ADD COLUMN     "last_name" VARCHAR(255) NOT NULL,
ADD COLUMN     "mobile_number" VARCHAR(255),
ADD COLUMN     "partner_id" TEXT NOT NULL;

-- CreateTable
CREATE TABLE "staff_profile" (
    "id" TEXT NOT NULL,
    "staff_id" TEXT NOT NULL,

    CONSTRAINT "staff_profile_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE UNIQUE INDEX "staff_profile_staff_id_key" ON "staff_profile"("staff_id");

-- CreateIndex
CREATE UNIQUE INDEX "staff_partner_id_key" ON "staff"("partner_id");

-- AddForeignKey
ALTER TABLE "staff" ADD CONSTRAINT "staff_partner_id_fkey" FOREIGN KEY ("partner_id") REFERENCES "partner"("id") ON DELETE NO ACTION ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE "staff_profile" ADD CONSTRAINT "staff_profile_staff_id_fkey" FOREIGN KEY ("staff_id") REFERENCES "staff"("id") ON DELETE CASCADE ON UPDATE NO ACTION;
