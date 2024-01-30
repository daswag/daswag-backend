import * as cdk from "aws-cdk-lib";
import {Construct} from "constructs";

export interface StageProps extends cdk.StageProps {
    readonly projectName: string;
    readonly domainName?: string;
    readonly terminationProtection?: boolean;
}

export class Stage extends cdk.Stage {
    constructor(scope: Construct, id: string, props: StageProps) {
        super(scope, id, props);

    }
}
