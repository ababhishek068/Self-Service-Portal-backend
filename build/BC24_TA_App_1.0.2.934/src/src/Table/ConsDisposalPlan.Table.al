table 50685 "Cons.Disposal Plan"
{

    fields
    {
        field(1; "Document No."; Code[20])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(2; "Document Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(3; "Disposal Period"; Code[10])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Disposal Period".Code;
        }
        field(4; Status; Option)
        {
            DataClassification = ToBeClassified;
            Description = 'Stores the status of the record in the database';
            Editable = false;
            OptionMembers = Pending,"1st Approval","2nd Approval","Cheque Printing",Posted,Cancelled,Checking,VoteBook,"Pending Approval",Approved;
        }
        field(5; "Approved By Board"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(6; "Approved By Committee"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(9; "Global Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,1,1';
            Caption = 'Global Dimension 1 Code';
            DataClassification = ToBeClassified;
            Description = 'Stores the reference to the first global dimension in the database';
            NotBlank = false;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));

            trigger OnValidate()
            begin
                Dimval.RESET;
                Dimval.SETRANGE(Dimval."Global Dimension No.", 1);
                Dimval.SETRANGE(Dimval.Code, "Global Dimension 1 Code");
                IF Dimval.FIND('-') THEN
                    "Function Name" := Dimval.Name
            end;
        }
        field(10; "Shortcut Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,2,2';
            Caption = 'Shortcut Dimension 2 Code';
            DataClassification = ToBeClassified;
            Description = 'Stores the reference of the second global dimension in the database';
            NotBlank = false;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2));

            trigger OnValidate()
            begin
                Dimval.RESET;
                Dimval.SETRANGE(Dimval."Global Dimension No.", 2);
                Dimval.SETRANGE(Dimval.Code, "Shortcut Dimension 2 Code");
                IF Dimval.FIND('-') THEN
                    "Budget Center Name" := Dimval.Name
            end;
        }
        field(11; "Function Name"; Text[100])
        {
            DataClassification = ToBeClassified;
            Description = 'Stores the name of the function in the database';
        }
        field(12; "Budget Center Name"; Text[100])
        {
            DataClassification = ToBeClassified;
            Description = 'Stores the name of the budget center in the database';
        }
        field(13; Description; Text[300])
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1; "Document No.")
        {
            Clustered = true;
        }
    }

    fieldgroups { }

    trigger OnInsert()
    begin
        IF "Document No." = '' THEN BEGIN
            ConsFinancialWorkplan.RESET;
            IF ConsFinancialWorkplan.FINDLAST THEN BEGIN
                "Document No." := INCSTR(ConsFinancialWorkplan."Document No.")
            END ELSE BEGIN
                "Document No." := 'DP-001';
            END;
        END;
    end;

    var
        ConsFinancialWorkplan: Record "Cons.Disposal Plan";
        Dimval: Record "Dimension Value";
}

