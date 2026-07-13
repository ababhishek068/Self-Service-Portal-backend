Page 50498 "Partially Active Files List"
{
    CardPageID = "Partially Active Files";
    PageType = List;
    SourceTable = "Registry Files";
    SourceTableView = where("File Status" = filter("Partially Active"));
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
                field(FileType; Rec."File Type")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the File Type field.';
                }
                field(MaximumAllowableFiles; Rec."Maximum Allowable Files")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Maximum Allowable Files field.';
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
        area(factboxes)
        {
            systempart(Control4; Notes) { }
            systempart(Control5; MyNotes) { }
            systempart(Control6; Links) { }
        }
    }

    actions
    {
        area(creation)
        {
            action(Bringup)
            {
                ApplicationArea = Basic;
                Caption = 'Set as Bring-up';
                Image = History;
                Promoted = true;
                PromotedIsBig = true;
                ToolTip = 'Executes the Set as Bring-up action.';

                trigger OnAction()
                begin
                    if (Confirm('Mark as Bring-up?', true) = false) then Error('Cancelled!');
                    Rec."File Status" := Rec."file status"::Bring_up;
                    Rec.Modify;
                    Message('File set as Bring-up!')
                end;
            }
            action(Archive)
            {
                ApplicationArea = Basic;
                Caption = 'Archive File';
                Image = Archive;
                Promoted = true;
                PromotedIsBig = true;
                ToolTip = 'Executes the Archive File action.';

                trigger OnAction()
                begin
                    if Confirm('Archive File?', false) = false then exit;

                    Rec."File Status" := Rec."file status"::Archived;
                    Rec.Modify;
                    Message('File archived!');
                end;
            }
        }
    }
}

