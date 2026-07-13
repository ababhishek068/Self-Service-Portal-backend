Page 50782 "Active Files Card"
{
    PageType = Document;
    SourceTable = "Registry Files";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            group(General)
            {
                field(FileNo; Rec."File No.")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the value of the File No. field.';
                }
                field(FileSubjectDescription; Rec."File Subject/Description")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the value of the File Subject/Description field.';
                }
                field(DateCreated; Rec."Date Created")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Date Created field.';
                }
                field(CreatedBy; Rec."Created By")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Created By field.';
                }
                field(FileType; Rec."File Type")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the value of the File Type field.';
                }
                field(MaximumAllowableFiles; Rec."Maximum Allowable Files")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Maximum Allowable Files field.';
                }
                field(DateofIssue; Rec."Date of Issue")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Date of Issue field.';
                }
                field(FileStatus; Rec."File Status")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the value of the File Status field.';
                }
                field(RequisitionNo; Rec."Requisition No")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Requisition No field.';
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
                field(ReceivingOffice; Rec."Receiving Office")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Receiving Office field.';
                }
                field(DispatchStatus; Rec."Dispatch Status")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Dispatch Status field.';
                }
                field("Disposal Type"; Rec."Disposal Type")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Disposal Type field.';
                }
            }
        }
        area(factboxes)
        {
            systempart(Control18; Notes) { }
            systempart(Control19; MyNotes) { }
            systempart(Control20; Links) { }
        }
    }

    actions
    {
        area(processing)
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
            action(Disposed)
            {
                ApplicationArea = Basic;
                Caption = 'Dispose File';
                Image = Archive;
                Promoted = true;
                PromotedIsBig = true;
                ToolTip = 'Executes the Dispose File action.';

                trigger OnAction()
                begin
                    if Confirm('Dispose File?', false) = false then exit;

                    Rec."File Status" := Rec."file status"::Disposed;
                    Rec.Modify;
                    Message('File disposed!');
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
            separator(Action24) { }
            action("Dispatch ")
            {
                ApplicationArea = Basic;
                Caption = 'Dispatch File';
                Image = Delivery;
                Promoted = true;
                ToolTip = 'Executes the Dispatch File action.';

                trigger OnAction()
                begin
                    if (Confirm('Dispatch File?', true) = false) then Error('Cancelled!');
                    Rec."Dispatch Status" := Rec."dispatch status"::Dispatched;
                    Rec.Modify;
                    Message('File Dispatched!')
                end;
            }

            action("Print/Preview")
            {
                Caption = 'Print/Preview';
                Image = Print;
                Promoted = true;
                PromotedCategory = "Report";
                ApplicationArea = ALL;
                PromotedIsBig = true;
                ToolTip = 'Executes the Print/Preview action.';

                trigger OnAction();
                begin
                    Rec.RESET;
                    Rec.SETFILTER("File No.", rec."File No.");
                    report.run(report::"File Movement Report", true, false, rec);
                end;
            }
        }
    }
}

