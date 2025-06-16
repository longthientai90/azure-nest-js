import { registerAs } from '@nestjs/config';
import { AppConfig } from "./config.type";

export default registerAs<AppConfig>('app', () => ({
  nodeEnv: process.env.NODE_ENV || 'development',
  frontendDomain: process.env.FRONTEND_DOMAIN,
  backendDomain: process.env.BACKEND_DOMAIN ?? 'http://localhost',
  port: process.env.APP_PORT
    ? parseInt(process.env.APP_PORT, 10)
    : process.env.PORT
    ? parseInt(process.env.PORT, 10)
    : 8080,
}));
