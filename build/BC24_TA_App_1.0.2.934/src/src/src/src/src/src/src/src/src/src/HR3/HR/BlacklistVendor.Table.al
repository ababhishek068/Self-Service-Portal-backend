table 51006 BlacklistVendor
{
    Caption = 'BlacklistVendor';
    DataClassification = ToBeClassified;
    DrillDownPageId="Vendor Blacklist List";
    
    fields
    {
        field(1; "Blacklist Code"; Code[20])
        {
            Caption = 'Blacklist Code';
        }
        field(2; "Vendor Code"; Code[20])
        {
            Caption = 'Vendor Code';
            TableRelation=Vendor."No.";
            trigger OnValidate()
            
            begin
                ven.Reset();
                ven.SetRange(ven."No.",rec."Vendor Code");
                if ven.FindFirst() then begin
                    "Vendor Name":=ven.Name;
                end;

            end;
        }
        field(3; "Vendor Name"; Text[50])
        {
            Caption = 'Vendor Name';
            Editable=false;
        }
        field(4; "Contract No"; Code[20])
        {
            Caption = 'Contract No';
            TableRelation=Contract."Contract Reference No" where("Contractor No."=field("Vendor Code"));
            trigger OnValidate()
            begin
                TestField("Vendor Code");
                contract.Reset();
                contract.SetRange(contract."Contract Reference No","Contract No");
                contract.SetRange(contract."Contractor No.","Vendor Code");
                if contract.FindFirst() then begin

                    "Contract Name":=contract."Contract Name";
                    "Contract Value":=contract."Contract Value";
                    "Contract Start Date":=contract."Effective Date";
                    "Contract Period":=contract.Duration;
                    "Contract End date":=contract."Expiry Date";
                end;
            end;
        }
        field(5; "Contract Name"; Text[100])
        {
            Caption = 'Contract Name';
            Editable=false;
        }
        field(6; "Contract Value"; Decimal)
        {
            Caption = 'Contract Value';
            Editable=false;
        }
        field(7; "Contract Start Date"; Date)
        {
            Caption = 'Contract Start Date';
            Editable=false;
        }
        field(8; "Contract Period"; DateFormula)
        {
            Caption = 'Contract Period';
            Editable=false;
        }
        field(9; "Contract End date"; Date)
        {
            Caption = 'Contract End date';
            Editable=false;
        }
        field(10; "Reason Code"; Code[20])
        {
            Caption = 'Reason Code';
        }
        field(11; "Summary Reason for Blaclist"; Text[1000])
        {
            Caption = 'Summary Reason for Blaclist';
        }
        field(12; "Blacklisting Start Date"; Date)
        {
            Caption = 'Blacklisting Start Date';
        }
        field(13; "Blacklisting End Date"; Date)
        {
            Caption = 'Blacklisting End Date';
            Editable=false;
        }
        field(14; "Blacklist Period"; DateFormula)
        {
            Caption = 'Blacklist Period';
            trigger OnValidate()
            begin
                TestField("Blacklisting Start Date");
                "Blacklisting End Date":=CalcDate("Blacklist Period","Blacklisting Start Date");
            end;
        }
        field(15; Status; Option)
        {
            Caption = 'Status';
            OptionMembers=Open,Approved,Rejected;
        }
        field(16; "Date Approved"; Date)
        {
            Caption = 'Date Approved';
            //Editable=false;
        }
        field(17; "Created By"; Code[40])
        {
            Caption = 'Created By';
            Editable=false;
        }
        field(18; "Date Created"; Date)
        {
            Caption = 'Date Created';
            Editable=false;
        }
        field(19; "Time Created"; time)
        {
            Caption = 'Time Created';
            Editable=false;
        }
        field(20;"Vendor Response";text[250]){}
        field(21;"Vendor Response Date";date){}
        field(22;"Vendor Response Ref No";code[20]){}
    }
    keys
    {
        key(PK; "Blacklist Code")
        {
            Clustered = true;
        }
    }
    trigger OnInsert()
    begin
        "Created By":=UserId;
        "Date Created":=Today;
        "Time Created":=Time;
    end;
    var
    ven: Record Vendor;
    contract: Record Contract;
}
