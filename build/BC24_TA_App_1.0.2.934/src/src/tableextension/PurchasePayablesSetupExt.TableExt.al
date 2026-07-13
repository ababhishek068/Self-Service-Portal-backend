tableextension 50003 "Purchase Payables Setup Ext" extends "Purchases & Payables Setup"
{
    fields
    {
        
        field(80000; "Company Workplan Nos."; Code[20])
        {
            TableRelation = "No. Series".Code;
        }
        field(50000;"Inspection Nos.";code[20]){
            TableRelation = "No. Series".Code;
        }
        field(50001;"Minutes Nos";code[20]){TableRelation = "No. Series".Code;}
        field(50002;"Appointment Nos.";code[20]){}

        field(80001; "Contract No."; Code[20])
        {
            Caption = 'Contract No.';
            DataClassification = ToBeClassified;
            TableRelation = "No. Series".Code;
        }

        field(80002; "Disposal Plan No."; Code[20])
        {
            Caption = 'Disposal Plan No.';
            DataClassification = ToBeClassified;
            TableRelation = "No. Series".Code;
        }

        field(80003; "Quotation Request No"; Code[20])
        {
            Caption = 'Quotation Request No.';
            DataClassification = ToBeClassified;
            TableRelation = "No. Series".Code;
        }
        field(80004; "Requisition No"; Code[20])
        {
            Caption = 'Requisition No';
            DataClassification = ToBeClassified;
            TableRelation = "No. Series".Code;
        }
        field(80005; "Disposal No."; Code[20])
        {
            Caption = 'Disposal No.';
            DataClassification = ToBeClassified;
            TableRelation = "No. Series".Code;
        }
        field(80006; "Vendor Buffer No."; Code[20])
        {
            Caption = 'Vendor Buffer No.';
            DataClassification = ToBeClassified;
            TableRelation = "No. Series".Code;

        }

        field(80007; "Tender Bid Nos"; Code[20])
        {
            Caption = 'Tender Bid Nos';
            DataClassification = ToBeClassified;
            TableRelation = "No. Series".Code;
        }

        field(80008; "Shipment Notification Nos"; Code[20])
        {
            Caption = 'Shipment Notification Nos';
            DataClassification = ToBeClassified;
            TableRelation = "No. Series".Code;
        }

        field(80009; "Portal Path"; Text[250])
        {
            Caption = 'Portal Path';
            DataClassification = ToBeClassified;
        }
        field(80010; "Contract Addendum Nos"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "No. Series".Code;
        }
        field(80011; "Low Value Proc Service"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Receipts and Payment Types".Code where(Type = filter('IMPREST'));
        }
        field(80012; "Purch Req Validate Quatity"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(80013; "RFQ Committee Members Limit"; Integer)
        {
            DataClassification = ToBeClassified;
        }

        field(80014; "Auto Convert Quote to Order"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(80015; "Item GL Budget"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(80016; "EOI Nos"; Code[20])
        {
            Caption = 'Expression of Intrest Nos';
            DataClassification = ToBeClassified;
            TableRelation = "No. Series".Code;
        }
        field(80017; "LPO Report No."; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(80018; "Default Vendor Posting Group"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Vendor Posting Group".Code;
        }
        field(80019; "Enable Vendor Notifications"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(80020; "Portal URL"; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(80021; "Supplier Support Address"; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(80022; "Disable printing of open LPO"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(80023; "Requisition Default Vendor"; Code[30])
        {
            DataClassification = ToBeClassified;
            TableRelation = Vendor."No.";
        }
        //
    }
}

