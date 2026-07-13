TableExtension 50017 "Job Cue Ext" extends "Job Cue"
{
    fields
    {
        field(23; "Pending Tasks"; Integer)
        {
            CalcFormula = count("User Task" where("Assigned To User Name" = field("User ID Filter"),
                                                   "Percent Complete" = filter(<> 100)));
            Caption = 'Pending Tasks';
            FieldClass = FlowField;
        }
        field(39003900; "Concept Notes"; Integer)
        {
            CalcFormula = count(Jobs where(Status = const("Concept Formulation"),
                                            "Approval Status" = filter(Open | "Pending Approval")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(39003901; Proposals; Integer)
        {
            CalcFormula = count(Jobs where(Status = const(Proposal),
                                            "Approval Status" = filter(Open | "Pending Approval")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(39003902; Projects; Integer)
        {
            CalcFormula = count(Jobs where(Status = const(Contract),
                                            "Approval Status" = filter(Open | "Pending Approval")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(39003903; Compliance; Integer)
        {
            CalcFormula = count("Compliance journal");
            FieldClass = FlowField;
        }
    }
}

