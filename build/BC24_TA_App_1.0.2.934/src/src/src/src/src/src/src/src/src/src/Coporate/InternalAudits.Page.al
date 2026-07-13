Page 50554 "Internal Audits"
{
    CardPageID = "Internal Audits Card";
    PageType = List;
    SourceTable = Audits;
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
                field(AnnualAuditCode; Rec."Audit Programme")
                {
                    ApplicationArea = Basic;
                    Caption = 'Annual Audit Code';
                    ToolTip = 'Specifies the value of the Annual Audit Code field.';
                }
                field(Quarter; Rec.Quarter)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Quarter field.';
                }
                field(QuarterAuditFromDate; Rec."Audit From Date")
                {
                    ApplicationArea = Basic;
                    Caption = 'Quarter Audit From Date';
                    ToolTip = 'Specifies the value of the Quarter Audit From Date field.';
                }
                field(QuarterAuditToDate; Rec."Audit To Date")
                {
                    ApplicationArea = Basic;
                    Caption = 'Quarter Audit To Date';
                    ToolTip = 'Specifies the value of the Quarter Audit To Date field.';
                }
                field(LeadersAppointmentDate; Rec."Leaders Appointment Date")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Leaders Appointment Date field.';
                }
                field(MembersAppointmentDate; Rec."Members Appointment Date")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Members Appointment Date field.';
                }
                field(FollowUpToDate; Rec."Follow Up To Date")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Follow Up To Date field.';
                }
                field(ReviewToDate; Rec."Review To Date")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Review To Date field.';
                }
                field(FollowUpFromDate; Rec."Follow Up From Date")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Follow Up From Date field.';
                }
                field(ReviewFromDate; Rec."Review From Date")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Review From Date field.';
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Status field.';
                }
                field(DateCreated; Rec."Date Created")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Date Created field.';
                }
                field(Sequence; Rec.Sequence)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Sequence field.';
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Description field.';
                }
                field(CreatedBy; Rec."Created By")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Created By field.';
                }
                field(Name; Rec.Name)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Name field.';
                }
            }
        }
    }

    actions { }
}

