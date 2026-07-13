Table 50252 Projects
{

    fields
    {
        field(1; No; Code[20]) { }
        field(2; "Customer No"; Code[20])
        {
            TableRelation = Customer."No.";

            trigger OnValidate()
            begin
                if Cust.Get("Customer No") then "Customer Name" := Cust.Name;
            end;
        }
        field(3; "Project Type"; Option)
        {
            OptionCaption = ' ,Implementation,Support';
            OptionMembers = " ",Implementation,Support;
        }
        field(4; "Start Date"; Date) { }
        field(5; "End Date"; Date) { }
        field(6; Status; Option)
        {
            OptionCaption = ' ,Ongoing,Suspended,Complete,On-call';
            OptionMembers = " ",Ongoing,Suspended,Complete,"On-call";
        }
        field(7; "Project Owner"; Code[20])
        {
            TableRelation = "HR-Employee"."No." where(Status = const(Active));
        }
        field(8; "No. Series"; Code[20]) { }
        field(9; "Customer Name"; Text[100]) { }
        field(10; "Project Description"; Text[50]) { }
        field(11; Cost; Decimal) { }
        field(12; "Project Status Summary"; Text[250]) { }
        field(13; "QR Code"; Blob)
        {
            SubType = Bitmap;
        }
    }

    keys
    {
        key(Key1; No)
        {
            Clustered = true;
        }
        key(Key2; "Customer Name") { }
    }

    fieldgroups { }

    trigger OnInsert()
    begin
        SalesSetup.Get;
        //NoSeriesMgt.GetNextNo(SalesSetup."Projects Nos",xRec."No. Series",0D,No,"No. Series");
    end;

    var
        SalesSetup: Record "Sales & Receivables Setup";
        Cust: Record Customer;
}

