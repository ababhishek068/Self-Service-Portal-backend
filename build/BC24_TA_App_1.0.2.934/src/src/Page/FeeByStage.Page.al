Page 50054 "Fee By Stage"
{
    PageType = ListPlus;
    SourceTable = "Fee By Stage";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Control1000000000)
            {
                field(Semester; Rec.Semester)
                {
                    ApplicationArea = Basic;
                    Visible = false;
                    ToolTip = 'Specifies the value of the Semester field.';
                }
                field(StudentType; Rec."Student Type")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                    ToolTip = 'Specifies the value of the Student Type field.';
                }
                field(SettlemetType; Rec."Settlemet Type")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Settlemet Type field.';
                }
                field(CampusCode; Rec."Campus Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Campus Code field.';
                }
                field(TuitionFees; Rec."Break Down")
                {
                    ApplicationArea = Basic;
                    Caption = 'Tuition Fees';
                    ToolTip = 'Specifies the value of the Tuition Fees field.';
                }
                field(TotalCharges; Rec."Total Charges")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Total Charges field.';
                }
                field(TotalFees; Rec."Break Down" + Rec."Total Charges")
                {
                    ApplicationArea = Basic;
                    Caption = 'Total Fees';
                    ToolTip = 'Specifies the value of the Total Fees field.';
                }
                field(Remarks; Rec.Remarks)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Remarks field.';
                }
                field(Seq; Rec."Seq.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Seq. field.';
                }
            }
        }
    }

    actions
    {
        area(Navigation)
        {
            action(Charges)
            {
                ApplicationArea = Basic;
                Image = Allocations;
                Promoted = true;
                RunObject = Page "Stage Charges";
                RunPageLink = "Programme Code" = field("Programme Code"),
                              "Stage Code" = field("Stage Code"),
                              Semester = field(Semester),
                              "Settlement Type" = field("Settlemet Type"),
                              "Campus Code" = field("Campus Code");
                ToolTip = 'Executes the Charges action.';
            }

        }
    }

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin
        Rec."Seq." := 1;
    end;
}

