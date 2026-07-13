table 50930 "Individualized Budgets"
{
    Caption = 'Individualized Budgets';
    DataClassification = ToBeClassified;
    LookupPageId="Individualized Budget Card";
    
    fields
    {
        field(1; "Financial Year"; Code[20])
        {
            Caption = 'Financial Year';
            DataClassification = CustomerContent;
        }
        field(2; "Department Code"; Code[20])
        {
            Caption = 'Department Code';
            DataClassification = CustomerContent;
                        TableRelation = "Dimension Value".Code where("Global Dimension No." = const(3));

            trigger OnValidate()
            begin
                TestField("Budget No");

                DimVal.Reset;
                DimVal.SetRange(DimVal.Code, "Department Code");
                if DimVal.Find('-') then
                    "Department Name" := DimVal.Name;
            end;
        }
        field(3; "Department Name"; Text[50])
        {
            Caption = 'Department Name';
            DataClassification = CustomerContent;
            Editable=false;
        }
        field(4; "GL account"; Code[20])
        {
            Caption = 'GL account';
            DataClassification = CustomerContent;
            TableRelation="G/L Account"."No." where("Account Category"=filter(Assets),"Account Type"=filter(Posting));
            trigger OnValidate()
            begin
                TestField("Budget No");
                TestField("Department Code");
            end;
        }
        field(5; "GL Name"; Text[50])
        {
            Caption = 'GL Name';
            DataClassification = CustomerContent;
            Editable=false;
        }
        field(6; Description; Text[250])
        {
            Caption = 'Description';
            DataClassification = CustomerContent;
            trigger OnValidate()
            begin
                TestField("Department Code");
                TestField("Financial Year");
                TestField("GL account");
            end;
        }
        field(7; "Created By"; Code[50])
        {
            Caption = 'Created By';
            DataClassification = CustomerContent;
            Editable=false;
        }
        field(8; "Date Created"; Date)
        {
            Caption = 'Date Craeted';
            DataClassification = CustomerContent;
            Editable=false;
        }
        field(9; "Total  Amount"; Decimal)
        {
            Caption = 'Total  Amount';
            DataClassification = CustomerContent;
            Editable=false;
        }
        field(10; "Total Expenditure"; Decimal)
        {
            Caption = 'Total Expenditure';
            Editable=false;
        }
        field(11; "Total Committments"; Decimal)
        {
            Caption = 'Total Committments';
            Editable=false;
        }
        field(12; Balance; Decimal)
        {
            Caption = 'Balance';
            Editable=false;
        }
        field(13; "Budget No"; Code[20])
        {
            Caption = 'Budget Number';
            Editable=true;
            TableRelation="G/L Budget Name".Name;
        }
    }
    keys
    {
        key(PK; "Budget No","Financial Year","Department Code","GL account")
        {
            Clustered = true;
        }
    }
     var
        DimVal: Record "Dimension Value";
}
