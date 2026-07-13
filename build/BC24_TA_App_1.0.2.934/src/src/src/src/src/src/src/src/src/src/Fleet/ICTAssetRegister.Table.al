table 50245 "ICT Asset Register"
{
    DataClassification = ToBeClassified;
    fields
    {
        field(1; "Asset No"; Code[20])
        {
            Caption = 'Asset No';
            TableRelation = "Fixed Asset"."No.";
            trigger OnValidate()
            var
                FA: Record "Fixed Asset";
            begin
                if FA.get("Asset No") then
                    "Asset Description" := Fa.Description;
            end;
        }
        field(2; "Asset Description"; Text[100]) { }
        field(4; "Assigned Officer"; Code[20])
        {
            TableRelation = "HR-Employee"."No.";
            trigger OnValidate()
            var
                HREmp: Record "HR-Employee";
            begin
                if HREmp.GET("Assigned Officer") then
                    "Assined Officer Name" := HREmp."First Name" + ' ' + HREmp."Middle Name" + ' ' + HREmp."Last Name";
            end;
        }
        field(5; "Assined Officer Name"; Text[100])
        {
            TableRelation = "HR-Employee"."No.";
        }
        field(6; "Asset Owner"; Code[20])
        {
            TableRelation = "HR-Employee"."No.";
            trigger OnValidate()
            var
                HREmp: Record "HR-Employee";
            begin
                if HREmp.GET("Asset Owner") then
                    "Asset Owner Name" := HREmp."First Name" + ' ' + HREmp."Middle Name" + ' ' + HREmp."Last Name";
            end;
        }
        field(7; "Asset Owner Name"; Text[100]) { }
        field(8; "Line No"; Integer)
        {
            AutoIncrement = true;
        }
        field(9; "Last Service Date"; Date) { }
        field(10; "Next Service Date"; Date) { }
        field(11; "Asset Location"; Text[50]) { }
    }

    keys
    {
        key(Key1; "Asset No")
        {
            Clustered = true;
        }
    }

    fieldgroups { }
}