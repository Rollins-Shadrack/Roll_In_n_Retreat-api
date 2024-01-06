/*
  Warnings:

  - Added the required column `link` to the `hold` table without a default value. This is not possible if the table is not empty.

*/
-- AlterTable
ALTER TABLE "hold" ADD COLUMN     "link" JSONB NOT NULL;
