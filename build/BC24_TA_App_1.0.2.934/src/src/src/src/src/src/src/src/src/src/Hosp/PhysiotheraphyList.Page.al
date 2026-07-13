Page 50845 "Physiotheraphy List"
{
    //  CardPageID = "HMS Physio Form Header";
    PageType = List;
    SourceTable = "HMS Physiotherapy Form Header";
    SourceTableView = where(Closed = const(false));
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {

                field(PatientNo; Rec."Patient No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Patient No. field.';
                }
                field(StudentNo; Rec."Student No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Student No. field.';
                }
                field(EmployeeNo; Rec."Employee No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Employee No. field.';
                }

                field(RelativeNo; Rec."Relative No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Relative No. field.';
                }

                field(LinkType; Rec."Link Type")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Link Type field.';
                }
                field(LinkNo; Rec."Link No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Link No. field.';
                }
                field(NoSeries; Rec."No. Series")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the No. Series field.';
                }
                field(Closed; Rec.Closed)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Closed field.';
                }

                field(Completed; Rec.Completed)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Completed field.';
                }

            }
        }
    }

    actions
    {
        area(processing)
        {
            action(Physio)
            {
                ApplicationArea = Basic;
                Caption = 'Physio List';
                Image = List;
                ToolTip = 'Executes the Physio List action.';
                // RunObject = Page UnknownPage70135297;
            }
        }
    }


}

