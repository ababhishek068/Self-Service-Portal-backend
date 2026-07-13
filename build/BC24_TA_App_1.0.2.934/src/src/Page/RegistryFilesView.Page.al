Page 50749 "Registry Files View"
{
    Editable = false;
    PageType = List;
    SourceTable = "Registry Files";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(FileNo; Rec."File No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the File No. field.';
                }
                field(FileSubjectDescription; Rec."File Subject/Description")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the File Subject/Description field.';
                }
                field(DateCreated; Rec."Date Created")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Date Created field.';
                }
                field(CreatedBy; Rec."Created By")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Created By field.';
                }
                field(MaximumAllowableFiles; Rec."Maximum Allowable Files")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Maximum Allowable Files field.';
                }
                field(FileType; Rec."File Type")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the File Type field.';
                }
                field(DateofIssue; Rec."Date of Issue")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Date of Issue field.';
                }
                field(IssuingOfficer; Rec."Issuing Officer")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Issuing Officer field.';
                }
                field(CirculationReason; Rec."Circulation Reason")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Circulation Reason field.';
                }
                field(ExpectedReturnDate; Rec."Expected Return Date")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Expected Return Date field.';
                }
                field(ReceivingOfficer; Rec."Receiving Officer")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Receiving Officer field.';
                }
                field(DeliveryOfficer; Rec."Delivery Officer")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Delivery Officer field.';
                }
                field(FileStatus; Rec."File Status")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the File Status field.';
                }
                field(DispatchStatus; Rec."Dispatch Status")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Dispatch Status field.';
                }
            }
        }
    }

    actions { }
}

