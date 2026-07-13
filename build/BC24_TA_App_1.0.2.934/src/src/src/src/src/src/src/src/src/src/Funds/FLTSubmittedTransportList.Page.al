Page 50622 "FLT Submitted Transport List"
{
    CardPageID = "FLT Submitted Transport Req";
    DeleteAllowed = false;
    InsertAllowed = false;
    PageType = List;
    SourceTable = "FLT-Transport Requisition";
    SourceTableView = where(Status = filter("Pending Approval"));
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field(TransportRequisitionNo; Rec."Transport Requisition No")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Transport Requisition No field.';
                }
                field(Commencement; Rec.Commencement)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Commencement field.';
                }
                field(Destination; Rec.Destination)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Destination field.';
                }
                field(Name; Rec.Name)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Name field.';
                }
                field(DateofTrip; Rec."Date of Trip")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Date of Trip field.';
                }
                field(NoOfPassangers; Rec."No Of Passangers")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the No Of Passangers field.';
                }
                field(AuthorizedBy; Rec."Authorized  By")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Authorized  By field.';
                }
                field(Position; Rec.Position)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Position field.';
                }
                field(TransportOfficerRemarks; Rec."Transport Officer Remarks")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Transport Officer Remarks field.';
                }
                field(HODRecommendations; Rec."HOD Recommendations")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the HOD Recommendations field.';
                }
                field(FinanceOfficerComments; Rec."Finance Officer Comments")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Finance Officer Comments field.';
                }
                field(NoofDaysRequested; Rec."No of Days Requested")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the No of Days Requested field.';
                }
                field(RequestedBy; Rec."Requested By")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Requested By field.';
                }
                field(DateRequisitionReceived; Rec."Date Requisition Received")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Date Requisition Received field.';
                }
                field(DateofRequest; Rec."Date of Request")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Date of Request field.';
                }
                field(TimeRequisitionReceived; Rec."Time Requisition Received")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Time Requisition Received field.';
                }
                field(PNO; Rec."P/NO")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the P/NO field.';
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Status field.';
                }
                field(VehicleAllocated; Rec."Vehicle Allocated")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Vehicle Allocated field.';
                }
                field(DriverAllocated; Rec."Driver Allocated")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Driver Allocated field.';
                }
                field(VehicleAllocatedby; Rec."Vehicle Allocated by")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Vehicle Allocated by field.';
                }
                field(OpeningOdometerReading; Rec."Opening Odometer Reading")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Opening Odometer Reading field.';
                }
                field(PurposeofTrip; Rec."Purpose of Trip")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Purpose of Trip field.';
                }
                field(Comments; Rec.Comments)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Comments field.';
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            group(Functions)
            {
                Caption = '&Functions';
                action(Approvals)
                {
                    ApplicationArea = Basic;
                    Caption = 'Approvals';
                    Image = Approvals;
                    Promoted = true;
                    PromotedIsBig = true;
                    ToolTip = 'Executes the Approvals action.';

                    trigger OnAction()
                    begin
                        DocumentType := Documenttype::TransportRequest;
                        ApprovalEntries.SetRecordFilters(Database::"FLT-Transport Requisition", DocumentType, Rec."Transport Requisition No");
                        ApprovalEntries.Run;
                    end;
                }
                action(cancellsApproval)
                {
                    ApplicationArea = Basic;
                    Caption = 'Cancel Approval Re&quest';
                    Image = Cancel;
                    Promoted = true;
                    PromotedCategory = Category4;
                    PromotedIsBig = true;
                    ToolTip = 'Executes the Cancel Approval Re&quest action.';

                    trigger OnAction()
                    var
                        ApprovalMgt: Codeunit "Custom Approvals Codeunit";
                        DocType: Option Quote,"Order",Invoice,"Credit Memo","Blanket Order","Return Order","None","Payment Voucher","Petty Cash",Imprest,Requisition,ImprestSurrender,Interbank,TransportRequest,Maintenance,Fuel,ImporterExporter,"Import Permit","Export Permit",TR,"Safari Notice","Student Applications","Water Research","Consultancy Requests","Consultancy Proposals","Meals Bookings","General Journal","Student Admissions","Staff Claim",KitchenStoreRequisition,"Leave Application","Staff Advance","Staff Advance Accounting";
                        Variant: Variant;
                    begin
                        DocType := Doctype::TR;
                        Variant := Rec;
                        ApprovalMgt.OnSendDocForApproval(Variant);
                    end;
                }
                separator(Action25) { }
                action(PrintPreview)
                {
                    ApplicationArea = Basic;
                    Caption = 'Print/Preview';
                    Image = PrintReport;
                    Promoted = true;
                    PromotedIsBig = true;
                    ToolTip = 'Executes the Print/Preview action.';

                    trigger OnAction()
                    begin
                        //RESET;
                        //SETFILTER("No.","No.");
                        //REPORT.RUN(70135036,TRUE,TRUE,Rec);
                        //RESET;
                    end;
                }
            }
        }
    }

    var
        DocumentType: Option Quote,"Order",Invoice,"Credit Memo","Blanket Order","Return Order","None","Payment Voucher","Petty Cash",Imprest,Requisition,ImprestSurrender,Interbank,TransportRequest,Maintenance,Fuel,ImporterExporter,"Import Permit","Export Permit",TR,"Safari Notice","Student Applications","Water Research","Consultancy Requests","Consultancy Proposals","Meals Bookings","General Journal","Student Admissions","Staff Claim",KitchenStoreRequisition,"Leave Application";
        ApprovalEntries: Page "Approval Entries";
}

