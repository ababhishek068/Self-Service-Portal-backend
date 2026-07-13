Table 50897 "Cash Office Setup"

{
    LookupPageId = "Cash Office Setup UP";
    fields
    {
        field(1; "Primary Key"; Code[10]) { }
        field(50001; "Normal Payments No"; Code[10])
        {
            Caption = 'Receipts No';
            TableRelation = "No. Series";
        }
        field(50002; "Cheque Reject Period"; DateFormula) { }
        field(50003; "Petty Cash Payments No"; Code[10])
        {
            Caption = 'Petty Cash Payments No';
            TableRelation = "No. Series";
        }
        field(50004; "Current Budget"; Code[20])
        {
            TableRelation = "G/L Budget Name".Name;
        }
        field(50005; "Current Budget Start Date"; Date) { }
        field(50006; "Current Budget End Date"; Date) { }
        field(50009; "Surrender Template"; Code[20])
        {
            TableRelation = "Gen. Journal Template";
        }
        field(50010; "Surrender  Batch"; Code[20])
        {
            TableRelation = "Gen. Journal Batch".Name where("Journal Template Name" = field("Surrender Template"));
        }
        field(50011; "Payroll Template"; Code[20])
        {
            TableRelation = "Gen. Journal Template";
        }
        field(50012; "Payroll  Batch"; Code[20])
        {
            TableRelation = "Gen. Journal Batch".Name;
        }
        field(50013; "Payroll Control A/C"; Code[20])
        {
            TableRelation = "G/L Account";
        }
        field(50014; "PV Template"; Code[20])
        {
            TableRelation = "Gen. Journal Template";
        }
        field(50015; "PV  Batch"; Code[20])
        {
            TableRelation = "Gen. Journal Batch".Name where("Journal Template Name" = field("PV Template"));
        }
        field(50016; "Contract No"; Code[20])
        {
            TableRelation = "No. Series";
        }
        field(50017; "Receipts No"; Code[20])
        {
            TableRelation = "No. Series";
        }
        field(50018; "Petty Cash Voucher  Template"; Code[20])
        {
            TableRelation = "Gen. Journal Template";
        }
        field(50019; "Petty Cash Voucher Batch"; Code[20])
        {
            TableRelation = "Gen. Journal Batch".Name;
        }
        field(50020; "Max. Petty Cash Request"; Decimal) { }
        field(50022; "Imprest Req No"; Code[20])
        {

            TableRelation = "No. Series";
        }
        field(51022; "Memos Req No"; Code[20])
        {

            TableRelation = "No. Series";
        }
        field(50023; "Quatation Request No"; Code[20])
        {
            TableRelation = "No. Series";
        }
        field(50024; "Tender Request No"; Code[20])
        {
            TableRelation = "No. Series";
        }
        field(50025; "Transport Pay Type"; Code[20])
        {
            TableRelation = Temp;
        }
        field(50026; "Minimum Chargeable Weight"; Decimal) { }
        field(50027; "Imprest Surrender No"; Code[20])
        {
            Caption = 'Imprest Surrender No';
            TableRelation = "No. Series";
        }
        field(50028; "Bank Deposit No."; Code[20])
        {
            TableRelation = "No. Series";
        }
        field(50029; "InterBank Transfer No."; Code[20])
        {
            TableRelation = "No. Series";
        }
        field(50030; "PA Payment Vouchers Nos"; Code[20])
        {
            Caption = 'Farmers Payment Vouchers Nos.';
            TableRelation = "No. Series".Code;
        }
        field(50031; "Cash Request Nos"; Code[20])
        {
            TableRelation = "No. Series".Code;
        }
        field(50032; "Cash Issue Nos"; Code[20])
        {
            TableRelation = "No. Series".Code;
        }
        field(50033; "Cash Receipt Nos"; Code[20])
        {
            TableRelation = "No. Series".Code;
        }
        field(50133; "Asset Transfer Nos."; Code[20])
        {
            TableRelation = "No. Series".Code;
        }
        field(50134; "Receipts Posted Later"; Boolean) { }


        field(50034; "Cash Transfer Template"; Code[10])
        {
            TableRelation = "Gen. Journal Template".Name;
        }
        field(50035; "Cash Transfer Batch"; Code[10])
        {
            TableRelation = "Gen. Journal Batch".Name where("Journal Template Name" = field("Cash Transfer Template"));
        }
        field(50036; "Enable AutoTeller Monitor"; Boolean) { }
        field(50037; "Alert After ?(Mins)"; Integer) { }
        field(50038; "Transporter Depot"; Code[20])
        {
            CaptionClass = '1,1,1';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(1));
        }
        field(50039; "Transporter Department"; Code[20])
        {
            CaptionClass = '1,2,2';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(2));
        }
        field(50040; "Transporter Cashier"; Code[20])
        {
            TableRelation = "Cash Office User Template";
        }
        field(50041; "Transporter PayType"; Code[20])
        {
            TableRelation = "Receipts and Payment Types".Code where(Type = filter(Payment));
        }
        field(50042; "Cashier Transfer Nos"; Code[20])
        {
            TableRelation = "No. Series".Code;
        }
        field(50043; "Interim Transfer Account"; Code[20])
        {
            TableRelation = "Bank Account" where("Bank Type" = const(Cash));
        }
        field(50044; "Default Bank Deposit Slip A/C"; Code[20])
        {
            TableRelation = "Bank Account"."No.";
        }
        field(50045; "Staff Claim No"; Code[20])
        {
            Caption = 'Staff Claim No';
            TableRelation = "No. Series".Code;
        }
        field(50046; "Other Staff Advance No"; Code[20])
        {
            Caption = 'Other Staff Advance No';
            TableRelation = "No. Series".Code;
        }
        field(50047; "Staff Advance Surrender No"; Code[20])
        {
            Caption = 'Staff Adv. Surrender No';
            TableRelation = "No. Series".Code;
        }
        field(50048; "Prompt Cash Reimbursement"; Boolean) { }
        field(50049; "Payment Schedule No"; Code[20])
        {
            Caption = 'Payment Schedule No';
            TableRelation = "No. Series".Code;
        }
        field(50050; "Stores Requisition No"; Code[20])
        {
            Caption = 'Stores Requisition No';
            TableRelation = "No. Series".Code;
        }
        field(50089; "Cash Sale Invoice Nos"; Code[20])
        {

            TableRelation = "No. Series".Code;
        }
        field(50088; "Cash Sale Customer No"; Code[20])
        {

            TableRelation = customer."No.";
        }
        field(50051; "Items issue Template"; Code[10])
        {
            TableRelation = "Item Journal Template";
        }
        field(50052; "Items Issue Batch"; Code[10])
        {
            TableRelation = "Item Journal Batch".Name where("Journal Template Name" = field("Items issue Template"));
        }
        field(50053; "Quotation Request No"; Code[20])
        {
            TableRelation = "No. Series".Code;
        }
        field(50054; "Vote Transfer"; Code[20])
        {
            TableRelation = "No. Series".Code;
        }
        field(50055; "Item Cash Purchase Control Ac."; Code[20])
        {
            TableRelation = "G/L Account"."No.";
        }
        field(50056; "Requisition Default Vendor"; Code[20])
        {
            TableRelation = "Vendor"."No.";
        }
        field(50057; "Casual Payment Nos"; Code[20])
        {
            TableRelation = "No. Series".Code;
        }
        field(50058; "Casual Nos"; Code[20])
        {
            TableRelation = "No. Series".Code;
        }
        field(50059; "Parttimers Nos"; Code[20])
        {
            TableRelation = "No. Series".Code;
        }
        field(50060; "Disposal Plan Nos."; Code[20])
        {
            TableRelation = "No. Series".Code;
        }
        field(50061; "Disposal Process Nos."; Code[20])
        {
            TableRelation = "No. Series".Code;
        }
        field(50161; "Repair Request Nos."; Code[20])
        {
            TableRelation = "No. Series".Code;
        }

        field(50062; "Minimum Cheque Creation Amount"; Decimal) { }
        field(50063; "Apply Cash Expenditure Limit"; Boolean) { }
        field(50064; "Expenditure Limit Amount(LCY)"; Decimal) { }
        field(50065; "ICT Requisition Nos"; Code[20])
        {
            TableRelation = "No. Series".Code;
        }
        field(50066; "Maintenance Nos."; Code[20])
        {
            TableRelation = "No. Series".Code;
        }
        field(50067; "Asset Incident Nos."; Code[20])
        {
            TableRelation = "No. Series".Code;
        }
        field(50068; "Maintenance Plan Nos."; Code[20])
        {
            TableRelation = "No. Series".Code;
        }
        field(50069; "Motor Vehicle Maintenance Nos."; Code[20])
        {
            TableRelation = "No. Series".Code;
        }
        field(50166; "Payment Split Account"; Code[20])
        {
            TableRelation = "G/L Account"."No.";
        }
        field(50167; "Payment Posting Method"; option)
        {
            OptionMembers = "Source Document","Payment Vourcher","Payment Schedule";
        }
        field(50268; "Notify On Imprest Surrender"; boolean) { }
        field(50269; "Auto Post Due Imprest to Payroll"; boolean) { }

        field(50270; "Trucks Posting Group"; code[20])
        {
            TableRelation = "FA Posting Group".Code;
        }
        field(50271; "Imprest Control Type"; Option)
        {
            OptionMembers = "None","One Imprest","Two Imprest","Amount Limit";
        }
        field(50272; "Levy Rate"; Decimal)
        {
            DecimalPlaces = 3;

        }
        field(50273; "Max Levy Payable"; Decimal) { }
        field(50274; "Enable Imprest Memo"; Boolean) { }
        field(50275; "Multiple PV Layouts"; Boolean) { }
        field(50276; "GreenCom PV Nos"; Code[20])
        {
            TableRelation = "No. Series".Code;
        }
        field(50277; "Petty Cash Nos"; Code[20])
        {
            TableRelation = "No. Series".Code;
        }
        field(50278; "Store Issuance Nos"; Code[20])
        {
            TableRelation = "No. Series".Code;
        }
    }

    keys
    {
        key(Key1; "Primary Key")
        {
            Clustered = true;
        }
    }

    fieldgroups { }
}

