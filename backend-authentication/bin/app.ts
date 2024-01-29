#!/usr/bin/env node
import 'source-map-support/register';
import { readFileSync } from 'fs';
import { resolve } from 'path';

import { Stage } from '../lib/stage';
import {App} from 'aws-cdk-lib';

const REGION = process.env.REGION || 'eu-west-1';
const ENVIRONMENT = process.env.PROJECT_ENV || 'dev';
const PROJECT_NAME = process.env.PROJECT_NAME || `${ENVIRONMENT}-BackendAuthentication`;

const configFilePath = resolve(__dirname, `../config/${ENVIRONMENT.toLowerCase()}.config.json`);
const config = JSON.parse(readFileSync(configFilePath).toString());

const app = new App();

new Stage(app, PROJECT_NAME, {
    env: {
        account: process.env.CDK_DEFAULT_ACCOUNT,
        region: REGION,
    },
    ...config,
});

app.synth();
