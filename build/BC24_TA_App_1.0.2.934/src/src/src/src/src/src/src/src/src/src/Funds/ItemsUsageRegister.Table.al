table 50442 "Items Usage Register"
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "SRN No"; code[20])
        {
            TableRelation = "Store Requistion Header"."No." where("Posted Count" = filter(> 0));
            DataClassification = ToBeClassified;
        }
        field(2; "Item No"; code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = Item."No.";
            trigger OnValidate()
            var
                Itm: Record item;
            begin
                if Itm.get("Item No") then
                    Description := Itm.Description;
            end;
        }
        field(3; "Description"; text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(4; "Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(5; "Quantity Received"; Decimal)
        {
            DataClassification = ToBeClassified;
            trigger OnValidate()
            begin
                Balance := "Quantity Received" - "Quantity Used";
            end;
        }
        field(6; "Quantity Used"; Decimal)
        {
            DataClassification = ToBeClassified;
            trigger OnValidate()
            begin
                Balance := "Quantity Received" - "Quantity Used";
            end;
        }
        field(7; "Balance"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(8; "Responsible Person"; code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "HR-Employee"."No.";
        }
        field(9; "Remarks"; Text[200])
        {
            DataClassification = ToBeClassified;
        }
        field(10; Type; Option)
        {
            OptionMembers = ,Chemicals,Materials;
            OptionCaption = ' ,Chemicals,Materials';
            DataClassification = ToBeClassified;
        }
        field(11; "Type of Materials"; code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(12; "Section"; code[20])
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(PK; "Item No", "SRN No")
        {
            Clustered = true;
        }
    }

    trigger OnInsert()
    begin

    end;

    trigger OnModify()
    begin

    end;

    trigger OnDelete()
    begin

    end;

    trigger OnRename()
    begin

    end;

}