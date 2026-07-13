Page 50156 "Results Status List"
{
    CardPageID = "Results Status Labels";
    PageType = List;
    SourceTable = "Results Status";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Code"; Rec.Code)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Code field.';
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Description field.';
                }
                field(ProgrammeFilter; Rec."Programme Filter")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Programme Filter field.';
                }
                field(StageFilter; Rec."Stage Filter")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Stage Filter field.';
                }
                field(SemesterFilter; Rec."Semester Filter")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Semester Filter field.';
                }
                field(StatusMsg1; Rec."Status Msg1")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Status Msg1 field.';
                }
                field(StatusMsg2; Rec."Status Msg2")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Status Msg2 field.';
                }
                field(StatusMsg3; Rec."Status Msg3")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Status Msg3 field.';
                }
                field(StatusMsg4; Rec."Status Msg4")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Status Msg4 field.';
                }
                field(StatusMsg5; Rec."Status Msg5")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Status Msg5 field.';
                }
                field(StatusMsg6; Rec."Status Msg6")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Status Msg6 field.';
                }
                field(StatusMsg7; Rec."Status Msg7")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Status Msg7 field.';
                }
                field(StatusMsg8; Rec."Status Msg8")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Status Msg8 field.';
                }
                field(OrderNo; Rec."Order No")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Order No field.';
                }
                field(StudentTypeFilter; Rec."Student Type Filter")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Student Type Filter field.';
                }
                field(ShowRegRemarks; Rec."Show Reg. Remarks")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Show Reg. Remarks field.';
                }
                field(ManualStatusProcessing; Rec."Manual Status Processing")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Manual Status Processing field.';
                }
                field(Semester; Rec.Semester)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Semester field.';
                }
                field(Prefix; Rec.Prefix)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Prefix field.';
                }
                field(SessionFilter; Rec."Session Filter")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Session Filter field.';
                }
            }
        }
    }

    actions { }
}

