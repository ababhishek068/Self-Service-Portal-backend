page 50617 "FLT Transport Requisition"
{
    PageType = Document;
    SourceTable = "FLT-Transport Requisition";
    SourceTableView = WHERE(Status = FILTER(Open));
    UsageCategory = Documents;
    ApplicationArea = all;

    layout
    {
        area(content)
        {
            group(General)
            {
                field("Transport Requisition No"; Rec."Transport Requisition No")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Transport Requisition No field.';
                }
                field("Vehicle Type"; Rec."Vehicle Type")
                {
                    Caption = 'Requisition Type';
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Requisition Type field.';
                }
                field(From; Rec.Commencement)
                {
                    Caption = 'From';
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the From field.';
                }
                field("To"; Rec.Destination)
                {
                    Caption = 'Destination';
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Destination field.';
                }

                field("Travel Memo No"; Rec."Travel Memo No")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Travel Memo No field.';
                }
                field("Responsibility Center"; Rec."Responsibility Center")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Responsibility Center field.';
                }
                field("Date of Trip"; Rec."Date of Trip")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Date of Trip field.';
                }
                field("Time of trip"; Rec."Time of trip")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Time of trip field.';
                }
                field("No Of Passangers"; Rec."No Of Passangers")
                {
                    Editable = false;
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the No Of Passangers field.';
                }
                field("No of External Passengers"; Rec."No of External Passengers")
                {
                    Editable = false;
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the No of External Passengers field.';
                }
                field("No of Days Requested"; Rec."No of Days Requested")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the No of Days Requested field.';
                }
                field("Requested By"; Rec."Requested By")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Requested By field.';
                }
                field("Date of Request"; Rec."Date of Request")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Date of Request field.';
                }
                field("Time Requisition Received"; Rec."Time Requisition Received")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Time Requisition Received field.';
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Status field.';
                }
                field("Opening Odometer Reading"; Rec."Opening Odometer Reading")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Opening Odometer Reading field.';
                }
                field("Clossing ODO"; Rec."Clossing ODO")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Clossing ODO field.';
                }
                field("Purpose of Trip"; Rec."Purpose of Trip")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Purpose of Trip field.';
                }
                field(Comments; Rec.Comments)
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Comments field.';
                }
            }
            group(Lines)
            {
                Caption = 'Lines';
                part(Control29; "FLT Transport Requisition St")
                {
                    ApplicationArea = all;
                    SubPageLink = "Req No" = FIELD("Transport Requisition No");
                }

            }
            part(FltExternalTransport; "FLT-External Passengers")
            {
                Caption = 'External Passengers';
                ApplicationArea = all;
                SubPageLink = "Transport No."=field("Transport Requisition No");
            }
        }
        area(factboxes)
        {
            part("Attached Documents"; "Document Attachments")
            {
                ApplicationArea = All;
                Caption = 'Attachments';
                SubPageLink = "Table ID" = CONST(70135138),
                              "No." = FIELD("Transport Requisition No");
            }
        }
    }

    actions
    {
        area(processing)
        {

            action(Approvals)
            {
                Caption = 'Approvals';
                Image = Approvals;
                Promoted = true;
                PromotedIsBig = true;
                ApplicationArea = all;
                ToolTip = 'Executes the Approvals action.';
                trigger OnAction()
                begin
                    DocumentType := DocumentType::TR;
                    ApprovalEntries.SetRecordFilters(DATABASE::"FLT-Transport Requisition", DocumentType, Rec."Transport Requisition No");
                    ApprovalEntries.Run;
                end;
            }
            action(sendApproval)
            {
                Caption = 'Send A&pproval Request';
                Image = SendApprovalRequest;
                Promoted = true;
                PromotedCategory = Category4;
                PromotedIsBig = true;
                ApplicationArea = all;
                ToolTip = 'Executes the Send A&pproval Request action.';

                trigger OnAction()
                var
                    Variant: Variant;
                    ApprovalCU: Codeunit "Custom Approvals Codeunit";
                begin


                    Rec.TestField(Status, Rec.Status::Open);
                    // TESTFIELD( Commencement);
                    Rec.TestField(Destination);
                    Rec.TestField("Date of Trip");
                    Rec.TestField("Purpose of Trip");

                    Rec."Date Requisition Received" := Today;
                    Rec."Time Requisition Received" := Time;
                    Variant := rec;
                    ApprovalCU.CheckApprovalsWorkflowEnabled(Variant);
                    ApprovalCU.OnSendDocForApproval(Variant);

                end;
            }
            action(cancellsApproval)
            {
                Caption = 'Cancel Approval Re&quest';
                Image = Cancel;
                Promoted = true;
                PromotedCategory = Category4;
                PromotedIsBig = true;
                ApplicationArea = all;
                ToolTip = 'Executes the Cancel Approval Re&quest action.';
                trigger OnAction()
                var
                    Variant: Variant;
                    ApprovalCU: Codeunit "Custom Approvals Codeunit";
                begin
                    Variant := rec;
                    ApprovalCU.CheckApprovalsWorkflowEnabled(Variant);
                    ApprovalCU.OnCancelDocApprovalRequest(Variant);
                end;
            }
            separator(Separator28) { }
            action("Print/Preview")
            {
                Caption = 'Print/Preview';
                Image = PrintReport;
                Promoted = true;
                PromotedIsBig = true;
                ToolTip = 'Executes the Print/Preview action.';

                trigger OnAction()
                begin
                    transRe.Reset;
                    transRe.SetFilter(transRe."Transport Requisition No", Rec."Transport Requisition No");
                    if transRe.Find('-') then
                        REPORT.Run(70134765, true, true, transRe);
                    //RESET;
                end;
            }

        }
    }

    var
        // ApprovalMgt: Codeunit "Approvals Management";
        DocumentType: Option Quote,"Order",Invoice,"Credit Memo","Blanket Order","Return Order","None","Payment Voucher","Petty Cash",Imprest,Requisition,ImprestSurrender,Interbank,TransportRequest,Maintenance,Fuel,ImporterExporter,"Import Permit","Export Permit",TR,"Safari Notice","Student Applications","Water Research","Consultancy Requests","Consultancy Proposals","Meals Bookings","General Journal","Student Admissions","Staff Claim",KitchenStoreRequisition,"Leave Application";
        ApprovalEntries: Page "Approval Entries";
        transRe: Record "FLT-Transport Requisition";
}

