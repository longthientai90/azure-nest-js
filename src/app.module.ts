import { Module } from '@nestjs/common';
import { ItemModule } from "./modules/item/item.module";
import { CompanyModule } from "./modules/account/company/company.module";
import { ConfigModule } from "@nestjs/config";
import appConfig from "./config/app.config";
import azureConfig from "./config/azure.config";
import { AppController } from "./app.controller";

@Module({
  imports: [
    ConfigModule.forRoot({
      isGlobal: true,
      load: [appConfig, azureConfig],
      envFilePath: ['.env'],
    }),
    ItemModule,
    CompanyModule
  ],
  controllers: [AppController],
})
export class AppModule {}
