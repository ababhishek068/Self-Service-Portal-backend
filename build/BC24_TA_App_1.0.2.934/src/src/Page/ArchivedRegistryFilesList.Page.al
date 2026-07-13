Page 50489 "Archived Registry Files List"
{
    CardPageID = "Archived Registry Files Card";
    PageType = List;
    SourceTable = "Registry Files";
    SourceTableView = where("File Status" = filter(Archived));
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
            action(active)
            {
                ApplicationArea = Basic;
                Caption = 'Set as Active';
                Image = ActivateDiscounts;
                Promoted = true;
                PromotedIsBig = true;
                ToolTip = 'Executes the Set as Active action.';

                trigger OnAction()
                begin
                    if (Confirm('Mark as Active?', true) = false) then Error('Cancelled!');
                    Rec."File Status" := Rec."file status"::Active;
                    Rec.Modify;
                    Message('File set as Active!')
                end;
            }
            action(Bring_up)
            {
                ApplicationArea = Basic;
                Caption = 'Mark as Bring-up';
                Image = History;
                Promoted = true;
                PromotedIsBig = true;
                ToolTip = 'Executes the Mark as Bring-up action.';

                trigger OnAction()
                begin
                    if Confirm('Mark as Bring-Up?', false) = false then exit;

                    Rec."File Status" := Rec."file status"::Bring_up;
                    Rec.Modify;
                    Message('Set as Bring-up!');
                end;
            }
            action(part_act)
            {
                ApplicationArea = Basic;
                Caption = 'Partially Active';
                Image = AdjustItemCost;
                Promoted = true;
                PromotedIsBig = true;
                ToolTip = 'Executes the Partially Active action.';

                trigger OnAction()
                begin
                    if Confirm('Set As Partially Active?', false) = false then exit;

                    Rec."File Status" := Rec."file status"::"Partially Active";
                    Rec.Modify;
                    Message('File set as Partially Active');
                end;
            }
        }
    }
}

