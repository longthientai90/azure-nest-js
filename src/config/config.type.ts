export type AppConfig = {
  nodeEnv: string;
  frontendDomain?: string;
  backendDomain: string;
  port: number;
};

export type AuthConfig = {
  secret?: string;
  expires?: string;
};

export type DatabaseConfig = {
  url?: string;
  type?: string;
  host?: string;
  port?: number;
  password?: string;
  name?: string;
  username?: string;
};

export type MailConfig = {
  port: number;
  host?: string;
  user?: string;
  password?: string;
  defaultEmail?: string;
  defaultName?: string;
  secure?: boolean;
};
