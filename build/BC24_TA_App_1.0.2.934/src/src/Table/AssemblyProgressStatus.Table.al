table 50139 "Assembly Progress Status"
{
    DataClassification = ToBeClassified;
    LookupPageId = "Assembly Progress Status";
    fields
    {
        field(1; "Line No"; Integer)
        {
            DataClassification = ToBeClassified;
            AutoIncrement = true;
        }
        field(2; "No"; code[20])
        {
            DataClassification = ToBeClassified;

        }
        field(3; "Assembly Stage"; code[20])
        {
            TableRelation = "Production Status".code;
            DataClassification = ToBeClassified;

        }
        field(4; "Start Date"; date)
        {
            DataClassification = ToBeClassified;

        }
        field(5; "End Date"; date)
        {
            DataClassification = ToBeClassified;

        }
        field(6; "Current Stage"; Boolean)
        {
            DataClassification = ToBeClassified;
            trigger OnValidate()
            var
                AssemblyOrder: record "Assembly Header";
                AssemStatus: Record "Assembly Progress Status";
            begin
                AssemStatus.reset;
                AssemStatus.setrange(No, No);
                AssemStatus.setrange("Current Stage", true);
                if AssemStatus.find('-') then begin
                    repeat
                        if AssemStatus."Assembly Stage" <> "Assembly Stage" then begin
                            AssemStatus."Current Stage" := false;
                            AssemStatus.modify;
                        end;
                    until AssemStatus.next = 0;
                end;
                if AssemblyOrder.get(AssemblyOrder."Document Type"::Order, No) then begin
                    AssemblyOrder."Assembly Status" := "Assembly Stage";
                    AssemblyOrder.modify;
                end;
            end;
        }
    }

    keys
    {
        key(Key1; "Line No", No)
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