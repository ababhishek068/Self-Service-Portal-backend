Table 50755 "Registry Cue"
{

    fields
    {
        field(1; "Primary Key"; Code[10]) { }
        field(2; "New Files"; Integer)
        {
            CalcFormula = count("Registry Files" where("File Status" = filter(New)));
            FieldClass = FlowField;
        }
        field(3; "Bring-up Files"; Integer)
        {
            CalcFormula = count("Registry Files" where("File Status" = filter(Bring_up)));
            FieldClass = FlowField;
        }
        field(4; "Archived Files"; Integer)
        {
            CalcFormula = count("Registry Files" where("File Status" = filter(Archived)));
            FieldClass = FlowField;
        }
        field(5; "New Inbound Mails"; Integer)
        {
            CalcFormula = count("Mail Register" where("Direction Type" = filter("Incoming Mail (Internal)" | "Incoming Mail (External)"),
                                                       "Mail Status" = filter(New)));
            FieldClass = FlowField;
        }
        field(6; "Mail Sorting"; Integer)
        {
            CalcFormula = count("Mail Register" where("Direction Type" = filter("Incoming Mail (Internal)" | "Incoming Mail (External)"),
                                                       "Mail Status" = filter('')));
            FieldClass = FlowField;
        }
        field(7; "Sorted Mails"; Integer)
        {
            CalcFormula = count("Mail Register" where("Direction Type" = filter("Incoming Mail (Internal)" | "Incoming Mail (External)"),
                                                       "Mail Status" = filter(Sorted)));
            FieldClass = FlowField;
        }
        field(8; "New Outbound Mails"; Integer)
        {
            CalcFormula = count("Mail Register" where("Direction Type" = filter("Outgoing Mail (Internal)" | "Outgoing Mail (External)"),
                                                       "Mail Status" = filter(New)));
            FieldClass = FlowField;
        }
        field(9; Dispatch; Integer)
        {
            CalcFormula = count("Mail Register" where("Direction Type" = filter("Outgoing Mail (Internal)" | "Outgoing Mail (External)"),
                                                       "Mail Status" = filter(Dispatch)));
            FieldClass = FlowField;
        }
        field(10; Dispatched; Integer)
        {
            CalcFormula = count("Mail Register" where("Direction Type" = filter("Outgoing Mail (Internal)" | "Outgoing Mail (External)"),
                                                       "Mail Status" = filter(Dispatched)));
            FieldClass = FlowField;
        }
        field(11; "Active Files"; Integer)
        {
            CalcFormula = count("Registry Files" where("File Status" = filter(Active)));
            FieldClass = FlowField;
        }
        field(12; "Partially Active"; Integer)
        {
            CalcFormula = count("Registry Files" where("File Status" = filter("Partially Active")));
            FieldClass = FlowField;
        }
    }

    keys
    {
        key(Key1; "Primary Key")
        {
            Clustered = true;
        }
    }

    fieldgroups { }
}

