Table 50658 "HMS Laboratory Results Entry"
{
    //  DrillDownPageID = UnknownPage70135284;
    // LookupPageID = UnknownPage70135284;

    fields
    {
        field(1; "Laboratory No."; Code[20])
        {
            NotBlank = true;
        }
        field(4; "Laboratory Test Code"; Code[20])
        {
            NotBlank = true;
            TableRelation = "HMS Setup Lab Test".Code;

            trigger OnValidate()
            begin
                //hmsHospital.InsertPatientLabCharges("Laboratory No.","Laboratory Test Code");
            end;
        }
        field(5; "Laboratory Test Name"; Text[100])
        {
            CalcFormula = lookup("HMS Setup Lab Test".Description where(Code = field("Laboratory Test Code")));
            FieldClass = FlowField;
        }
        field(6; "Specimen Code"; Code[20])
        {
            TableRelation = "HMS Setup Specimen".Code;

            trigger OnValidate()
            begin
                LabParam.SetRange(LabParam."Laboratory Test Code", "Laboratory Test Code");
                LabParam.SetRange(LabParam."Specimen Code", "Specimen Code");
                if LabParam.Find('-') then begin
                    "Sort Test" := LabParam.Arrangement;
                end;
            end;
        }
        field(7; "Specimen Name"; Text[100])
        {
            CalcFormula = lookup("HMS Lab Parameters setup"."Specimen Name" where("Specimen Code" = field("Specimen Code")));
            FieldClass = FlowField;
        }
        field(8; "Assigned User ID"; Code[20])
        {
            TableRelation = "User Setup"."User ID";
        }
        field(9; "Collection Date"; Date) { }
        field(10; "Collection Time"; Time) { }
        field(11; "Measuring Unit Code"; Code[20])
        {
            CalcFormula = lookup("HMS Lab Parameters setup"."Measuring Unit Code" where("Specimen Code" = field("Specimen Code"),
                                                                                         "Laboratory Test Code" = field("Laboratory Test Code")));
            FieldClass = FlowField;
        }
        field(12; "Measuring Unit Name"; Text[30])
        {
            CalcFormula = lookup("HMS Lab Parameters setup"."Measuring Unit Name" where("Specimen Code" = field("Specimen Code"),
                                                                                         "Laboratory Test Code" = field("Laboratory Test Code")));
            FieldClass = FlowField;
        }
        field(13; Results; Decimal)
        {
            DecimalPlaces = 3 : 3;

            trigger OnValidate()
            begin
                LabParam.SetRange(LabParam."Laboratory Test Code", "Laboratory Test Code");
                LabParam.SetRange(LabParam."Specimen Code", "Specimen Code");
                if LabParam.Find('-') then begin
                    Flag := Flag::Normal;
                    if Results < LabParam."Min Range" then Flag := Flag::Low;
                    if Results > LabParam."Max Range" then Flag := Flag::High;
                end;
                //Remarks:=FORMAT(Results);
                LabParam.SetRange(LabParam."Laboratory Test Code", "Laboratory Test Code");
                LabParam.SetRange(LabParam."Specimen Code", "Specimen Code");
                if LabParam.Find('-') then begin
                    "Sort Test" := LabParam.Arrangement;
                end;
            end;
        }
        field(14; Remarks; Text[250])
        {

            trigger OnValidate()
            begin
                LabParam.SetRange(LabParam."Laboratory Test Code", "Laboratory Test Code");
                LabParam.SetRange(LabParam."Specimen Code", "Specimen Code");
                if LabParam.Find('-') then begin
                    "Sort Test" := LabParam.Arrangement;
                end;
            end;
        }
        field(15; Completed; Boolean) { }
        field(16; Positive; Boolean) { }
        field(17; "Test Normal Ranges"; Text[100])
        {
            CalcFormula = lookup("HMS Lab Parameters setup"."Test Normal Ranges" where("Laboratory Test Code" = field("Laboratory Test Code"),
                                                                                        "Specimen Code" = field("Specimen Code")));
            FieldClass = FlowField;
        }
        field(18; "Test Units"; Text[100])
        {
            FieldClass = Normal;
        }
        field(19; Flag; Option)
        {
            OptionCaption = ' ,Normal,High,Low';
            OptionMembers = " ",Normal,High,Low;
        }
        field(20; Reactive; Option)
        {
            OptionCaption = ',Reactive,Non-Reactive';
            OptionMembers = ,Reactive,"Non-Reactive";
        }
        field(21; "Normal Range"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(22; "Sort Test"; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(23; "Lab Test  Date"; Date)
        {
            CalcFormula = lookup("HMS Laboratory Form Header"."Laboratory Date" where("Laboratory No." = field("Laboratory No.")));
            FieldClass = FlowField;
        }
    }

    keys
    {
        key(Key1; "Laboratory No.", "Laboratory Test Code", "Specimen Code", "Sort Test", Results, Remarks)
        {
            Clustered = true;
        }
        key(Key2; "Laboratory No.", "Laboratory Test Code", "Sort Test", "Specimen Code") { }
    }

    fieldgroups { }

    var
        LabParam: Record "HMS Lab Parameters setup";
}

