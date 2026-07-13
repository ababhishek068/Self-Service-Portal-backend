Page 50765 "Registry Files Card"
{
    PageType = Card;
    SourceTable = "Registry Files";
    SourceTableView = where("File Status" = filter(New));
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
                    ToolTip = 'Specifies the value of the File No. field.';
                }


                field("Folio No"; Rec."Folio No")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Folio No field.';
                }
                field("File Subject/Description"; Rec."File Subject/Description")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the File Subject/Description field.';
                }
                field(DateofIssue; Rec."Date of Issue")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Date of Issue field.';
                }
                field(IssuingOfficer; Rec."Issuing Officer")
                {
                    Caption = 'Action Officer';
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Action Officer field.';
                }
                field(CirculationReason; Rec."Circulation Reason")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Circulation Reason field.';
                }
                field(ExpectedReturnDate; Rec."Expected Return Date")
                {
                    Caption = 'Date Returned';
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Date Returned field.';
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
                field(DeliveryOfficerName; Rec."Delivery Officer Name")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Delivery Officer Name field.';
                }

                field(IssuingOfficeName; Rec."Issuing Office Name")
                {
                    Caption = 'Issuing Office Name';
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Issuing Office Name field.';
                }
                field(RecievingOfficerName; Rec."Recieving Officer Name")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Recieving Officer Name field.';
                }

                field(FolioNo; Rec."Folio No")
                {
                    Visible = false;
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Folio No field.';
                }
                field(DepartmentCode; Rec."Department Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Department Code field.';
                }
                field("Disposal Type"; Rec."Disposal Type")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Disposal Type field.';
                }
                field("File Opening Request"; Rec."File Opening Request")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the File Opening Request field.';
                }
                field("File Return Time"; Rec."File Return Time")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the File Return Time field.';
                }
            }
        }
        area(factboxes)
        {
            part("Attached Documents"; "Document Attachments")
            {
                ApplicationArea = All;
                Caption = 'Attachments';
                SubPageLink = "Table ID" = CONST(70134918),
                              "No." = FIELD("File No.");
            }
            systempart(Control18; Notes) { }
            systempart(Control19; MyNotes) { }
            systempart(Control20; Links) { }
        }
    }

    actions
    {
        area(creation)
        {

            action(Bringup)
            {
                ApplicationArea = Basic;
                Caption = 'Set as Partialy Active';
                Image = History;
                Promoted = true;
                PromotedIsBig = true;
                ToolTip = 'Executes the Set as Partialy Active action.';

                trigger OnAction()
                begin
                    if (Confirm('Mark as Partialy?', true) = false) then Error('Cancelled!');
                    Rec."File Status" := Rec."file status"::"Partially Active";
                    Rec.Modify;
                    Message('File set as Partially Active!')
                end;
            }
            action("Dispatch ")
            {
                ApplicationArea = Basic;
                Caption = 'Dispatch File';
                ToolTip = 'Executes the Dispatch File action.';

                trigger OnAction()
                begin
                    if (Confirm('Dispatch File?', true) = false) then Error('Cancelled!');
                    Rec."Dispatch Status" := Rec."dispatch status"::Dispatched;
                    Rec.Modify;
                    Message('File Dispatched!')
                end;
            }
            action(Archive)
            {
                ApplicationArea = Basic;
                Caption = 'Archive File';
                ToolTip = 'Executes the Archive File action.';

                trigger OnAction()
                begin
                    if Confirm('Archive File?', false) = false then exit;

                    Rec."File Status" := Rec."file status"::Archived;
                    Rec.Modify;
                    Message('File archived!');
                end;
            }
            action(Dispos)
            {
                ApplicationArea = Basic;
                Caption = 'Dispose File';
                ToolTip = 'Executes the Dispose File action.';

                trigger OnAction()
                begin
                    if Confirm('Dispose File?', false) = false then exit;

                    Rec."File Status" := Rec."file status"::Disposed;
                    Rec.Modify;
                    Message('File disposed!');
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

