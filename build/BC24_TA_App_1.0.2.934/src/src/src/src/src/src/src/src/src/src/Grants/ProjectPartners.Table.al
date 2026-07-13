Table 50383 "Project Partners"
{
    DrillDownPageID = "Project Partners";
    LookupPageID = "Project Partners";

    fields
    {
        field(1; PartnerID; Code[20])
        {
            NotBlank = true;
            TableRelation = Vendor where(Blocked = filter(" "));

            trigger OnValidate()
            begin
                Cust.Get(PartnerID);
                "Partner Name" := Cust.Name;
            end;
        }
        field(2; "Partner Name"; Text[100]) { }
        field(3; "Partner Budget"; Decimal)
        {
            CalcFormula = sum("Job-Planning Line"."Total Cost (LCY)" where(Partner = field(PartnerID),
                                                                            "Grant No." = field("Grant No")));
            FieldClass = FlowField;
        }
        field(4; "Grant No"; Code[50])
        {
            NotBlank = true;
            TableRelation = Jobs;
        }
        field(5; "Reporting Date"; Date) { }
        field(6; "Disbursed Amount (LCY)"; Decimal)
        {
            CalcFormula = sum("Payment Line"."NetAmount LCY");
            FieldClass = FlowField;
        }
        field(7; Balance; Decimal)
        {
            Editable = false;
        }
        field(8; "Accounted Amount"; Decimal)
        {
            CalcFormula = sum("Grant Surrender Details"."Actual Spent" where("Grant No" = field("Grant No"),
                                                                              Partner = field(PartnerID),
                                                                              Posted = const(true)));
            Editable = false;
            FieldClass = FlowField;
        }
        field(9; "Contractor Type"; Option)
        {
            OptionCaption = ' ,Sub-Contractor,Prime';
            OptionMembers = " ","Sub-Contractor",Prime;
        }
    }

    keys
    {
        key(Key1; PartnerID, "Grant No")
        {
            Clustered = true;
        }
    }

    fieldgroups { }

    var
        Cust: Record Vendor;
}

