Page 51205 "CLosed Physiotheraphy List"
{
    //  CardPageID = "HMS Physio Form Header";
    PageType = List;
    SourceTable = "HMS Physiotherapy Form Header";
    ApplicationArea = All;
    // SourceTableView = where(Code=filter(2));

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Observation No."; Rec."Observation No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Observation No. field.';
                }
                field("Observation Date"; Rec."Observation Date")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Observation Date field.';
                }
                field("Patient No."; Rec."Patient No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Patient No. field.';
                }
                field("Patient Name"; Rec."Patient Name")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Patient Name field.';
                }

                field("Observation Remarks"; Rec."Observation Remarks")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Observation Remarks field.';
                }
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
                RunObject = Page "HMS Physiotherapy Types";
                ToolTip = 'Executes the Physio List action.';
            }
        }
    }
}

