Table 50512 "PR Vital Setup Info"
{
    LookupPageId = "PR Rates & Ceilings";
    fields
    {
        field(1; "Setup Code"; Code[10]) { }

        field(370; "Implement NHIF Relief"; boolean) { }
        field(490; "House Allowance Percentage"; Decimal) { }
        field(491; "Managerial Fuel litres"; Decimal) { }
        field(492; "Non-Managerial Fuel litres"; Decimal) { }

        field(371; "NHIF Relief Percentage"; Decimal) { }
        field(372; "Pension Rate"; Decimal) { }
        field(373; "Pension Lower Earning Limit(LEL)"; Decimal) { }
        field(374; "Pension Upper Earning Limit(UEL)"; Decimal) { }
        field(375; "Implement New Pension"; Boolean) { }


        field(2; "Tax Relief"; Decimal) { }
        field(3; "Insurance Relief"; Decimal) { }
        field(4; "Max Relief"; Decimal) { }

        field(5; "Mortgage Relief"; Decimal) { }
        field(6; "Max Pension Contribution"; Decimal) { }
        field(7; "Tax On Excess Pension"; Decimal) { }
        field(8; "Loan Market Rate"; Decimal) { }
        field(9; "Loan Corporate Rate"; Decimal) { }
        field(10; "Taxable Pay (Normal)"; Decimal) { }
        field(11; "Taxable Pay (Agricultural)"; Decimal) { }
        field(12; "NHIF Based on"; Option)
        {
            OptionMembers = Gross,Basic,"Taxable Pay";
        }
        field(13; "Pension Employee"; Decimal) { }
        field(14; "Pension Employer Factor"; Decimal) { }
        field(15; "OOI Deduction"; Decimal) { }
        field(16; "OOI December"; Decimal) { }
        field(17; "Security Day (U)"; Decimal) { }
        field(18; "Security Night (U)"; Decimal) { }
        field(19; "Ayah (U)"; Decimal) { }
        field(20; "Gardener (U)"; Decimal) { }
        field(21; "Security Day (R)"; Decimal) { }
        field(22; "Security Night (R)"; Decimal) { }
        field(23; "Ayah (R)"; Decimal) { }
        field(24; "Gardener (R)"; Decimal) { }
        field(25; "Benefit Threshold"; Decimal) { }
        field(26; "Pension Based on"; Option)
        {
            OptionMembers = Gross,Basic,"Taxable Pay";
        }
        field(27; "Value Posting"; Decimal) { }
        field(28; "Disbled Tax Limit"; Decimal) { }
        field(29; "Minimum Relief Amount"; Decimal) { }
        field(30; "Secondary Tax Percentage"; Decimal) { }
        field(31; "Mortgage Relief Percentage"; Decimal) { }
        field(32; "Payslip Message"; Text[50]) { }
        field(33; "PWD Staff Retirement Age"; Decimal) { }
        field(34; "Other Staff Retirement Age"; Decimal) { }
        field(35; "Minimum Taxable Pay"; Decimal) { }

        field(36; "Enable Payroll Proration"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(37; "Enable Relief On PAYE Only"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(50100; "PrPension Employer Code"; Code[30])
        {
            TableRelation = "PR Transaction Codes"."Transaction Code";
        }
        field(50101; "PrPension Employee Code"; Code[30])
        {
            TableRelation = "PR Transaction Codes"."Transaction Code";
        }
        field(50102; "Defined Maximum Fuel Allowance"; Decimal) { }
        field(50103; "Cost share percentage"; Decimal) { }
        field(50104; "Minimum take home"; Decimal)
        {
            Caption = 'Minimum Take Home % after Medical claim recovery';
        }
        field(50105; "Claims Code"; Code[20])
        {
            Caption = 'Scheme claims';
            TableRelation = "PR Transaction Codes"."Transaction Code" where("Transaction Type" = const(Deduction));
        }
        field(50106; "Overtime Code"; Code[20])
        {
            TableRelation = "PR Transaction Codes"."Transaction Code" where("Transaction Type" = const(Income));
        }
        field(50107; "% GlasFrames"; Decimal)
        {
            caption = '% for  Glass & Frames';
        }
        field(50108; "Fuel Rate"; Decimal) { }
        field(50109; "Mobi all code"; Code[20])
        {
            TableRelation = "PR Transaction Codes"."Transaction Code" where("Transaction Type" = const(Income));
        }
        field(50110; "House all code"; Code[20])
        {
            TableRelation = "PR Transaction Codes"."Transaction Code" where("Transaction Type" = const(Income));
        }
        field(5011; "Position all code"; Code[20])
        {
            TableRelation = "PR Transaction Codes"."Transaction Code" where("Transaction Type" = const(Income));
        }
        field(50112; "Fuel all code"; Code[20])
        {
            TableRelation = "PR Transaction Codes"."Transaction Code" where("Transaction Type" = const(Income),Taxable=filter(true));
        }
        field(50113; "Hardship all code"; Code[20])
        {
            TableRelation = "PR Transaction Codes"."Transaction Code" where("Transaction Type" = const(Income),Taxable=filter(true)
            );
        }
        field(50114; "Advance Deduction code"; Code[20])
        {
            TableRelation = "PR Transaction Codes"."Transaction Code" where("Transaction Type" = const(Deduction));
        }
        field(50115; "Advance Payable Account"; Code[50])
        {
            TableRelation = "G/L Account"."No." where("Account Category" = filter(Liabilities));
        }
        field(50117; "Guarantee Recovery code"; Code[20])
        {
            TableRelation = "PR Transaction Codes"."Transaction Code" where("Transaction Type" = const(Deduction));
        }
        field(50118; "Guarantee Refund code"; Code[20])
        {
            TableRelation = "PR Transaction Codes"."Transaction Code" where("Transaction Type" = const(Income));
        }
        field(50119; "Acting Allowance"; Code[20])
        {
            TableRelation = "PR Transaction Codes"."Transaction Code" where("Transaction Type" = const(Income));
        }
        field(50120; "Acting Allowance nontax"; code[20])
        {
            TableRelation = "PR Transaction Codes"."Transaction Code" where("Transaction Type" = const(Income), Taxable = filter(false));

        }
        field(50121; "Mobi all code Nontax"; Code[20])
        {
            TableRelation = "PR Transaction Codes"."Transaction Code" where("Transaction Type" = const(Income), Taxable = filter(false));
        }
        field(50122; "House all code nontax"; Code[20])
        {
            TableRelation = "PR Transaction Codes"."Transaction Code" where("Transaction Type" = const(Income), Taxable = filter(false));
        }
        field(50123; "Position all code nontax"; Code[20])
        {
            TableRelation = "PR Transaction Codes"."Transaction Code" where("Transaction Type" = const(Income), Taxable = filter(false));
        }
        field(50124; "Fuel all code nontax"; Code[20])
        {
            TableRelation = "PR Transaction Codes"."Transaction Code" where("Transaction Type" = const(Income), Taxable = filter(false));
        }
        field(50125; "Hardship all code nontax"; Code[20])
        {
            TableRelation = "PR Transaction Codes"."Transaction Code" where("Transaction Type" = const(Income), Taxable = filter(false));
        }
        field(50126; "Acting Representation all code"; Code[20])
        {
            TableRelation = "PR Transaction Codes"."Transaction Code" where("Transaction Type" = const(Income), Taxable = filter(true));
        }
        field(50127; "Acting Representation all nontax"; Code[20])
        {
            TableRelation = "PR Transaction Codes"."Transaction Code" where("Transaction Type" = const(Income), Taxable = filter(false));
        }
        field(50128; "% Staff Claim"; Decimal)
        {
            Caption = '% to recover from staff Claim';
        }
        field(50129;"Working in Office Tra";Decimal)
        {
            Caption='Working in office Transport Allowance Amount';
        }
        field(50130;"Out of Office Max Allowance";Decimal)
        {

        }
        field(50131;"Transport Allowance Percentage";Decimal){}
        field(50132;"Social Contriution Perc";decimal){
            DecimalPlaces=4;
        }
        field(50133;"Social ContributioCode";code[20]){
            Caption='Social Contribution Registration Code';
            TableRelation = "PR Transaction Codes"."Transaction Code" where("Transaction Type" = const(Deduction));            
        }
        field(50134;"Social Cont Registation Amount";Decimal)
        {
            Caption='Social Contribution Registation Amount';
        }
        field(50135;"Taxable Trans Allow Code";code[20]){
            Caption='Taxable Transport Allowance Code';
            TableRelation = "PR Transaction Codes"."Transaction Code" where("Transaction Type" = const(income), Taxable = filter(true));            
        }
        field(50136;"NonTaxable Trans Allow Code";code[20]){
            Caption='NonTaxable Transport Allowance Code';
            TableRelation = "PR Transaction Codes"."Transaction Code" where("Transaction Type" = const(income), Taxable = filter(false));            
        }
        field(50137;"Medical Refund percentage-Self";Decimal){
            Caption='Medical Refund percentage of budget pay-Self';
            //TableRelation = "PR Transaction Codes"."Transaction Code" where("Transaction Type" = const(income), Taxable = filter(false));            
        }
        field(50138;"Medical Refund percentage-dependant";Decimal){
            Caption='Medical Refund percentage of Budget pay-Dependant';
            //TableRelation = "PR Transaction Codes"."Transaction Code" where("Transaction Type" = const(income), Taxable = filter(false));            
        }



    }

    keys
    {
        key(Key1; "Setup Code")
        {
            Clustered = true;
        }
    }

    fieldgroups { }
}

