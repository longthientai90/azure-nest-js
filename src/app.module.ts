import { Module } from '@nestjs/common';
import { ItemModule } from "./modules/item/item.module";
import { ConfigModule } from "@nestjs/config";
import appConfig from "./config/app.config";
import azureConfig from "./config/azure.config";

@Module({
  imports: [
    ConfigModule.forRoot({
      isGlobal: true,
      load: [appConfig, azureConfig],
      envFilePath: ['.env'],
    }),
    ItemModule
  ],
})
export class AppModule {}
