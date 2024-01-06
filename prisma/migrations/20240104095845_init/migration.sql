/*
  Warnings:

  - Added the required column `entity` to the `account` table without a default value. This is not possible if the table is not empty.

*/
-- AlterTable
ALTER TABLE "account" ADD COLUMN     "entity" TEXT NOT NULL,
ADD COLUMN     "is_email_verified" BOOLEAN NOT NULL DEFAULT false,
ALTER COLUMN "account_type_id" DROP NOT NULL;

-- AlterTable
ALTER TABLE "user" ALTER COLUMN "gender" DROP NOT NULL;
