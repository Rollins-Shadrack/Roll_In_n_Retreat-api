/*
  Warnings:

  - You are about to drop the column `is_supper_admin` on the `staff` table. All the data in the column will be lost.

*/
-- AlterTable
ALTER TABLE "staff" DROP COLUMN "is_supper_admin",
ADD COLUMN     "is_super_admin" BOOLEAN NOT NULL DEFAULT false;
