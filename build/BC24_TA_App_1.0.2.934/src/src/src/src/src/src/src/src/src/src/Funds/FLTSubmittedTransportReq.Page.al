Page 50620 "FLT Submitted Transport Req"
{
    DeleteAllowed = false;
    InsertAllowed = false;
    PageType = Document;
    SourceTable = "FLT-Transport Requisition";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            group(General)
            {
                field(TransportRequisitionNo; Rec."Transport Requisition No")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Transport Requisition No field.';
                }
                field("Vehicle Type"; Rec."Vehicle Type")
                {
                    Caption = 'Requisition Type';
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Requisition Type field.';
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
                field("Travel Memo No"; Rec."Travel Memo No")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Travel Memo No field.';
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
                    Caption = 'Vehicle / Vessel Allocatd';
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Vehicle / Vessel Allocatd field.';
                }
                field("Vehicle Registration"; Rec."Vehicle Registration")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Vehicle Registration field.';
                }
                field(DriverAllocated; Rec."Driver Allocated")
                {
                    Caption = 'Driver/ Coxswain Allocated';
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Driver/ Coxswain Allocated field.';
                }
                field("Driver Name"; Rec."Driver Name")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Driver Name field.';
                }
                field(VehicleAllocatedby; Rec."Vehicle Allocated by")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Vehicle Allocated by field.';
                }
                field("External Driver"; Rec."External Driver")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the External Driver field.';
                }
                field("External Vehicle"; Rec."External Vehicle")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the External Vehicle field.';
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
            part(Control29; "FLT Transport Requisition St")
            {
                ApplicationArea = Basic;

                SubPageLink = "Req No" = field("Transport Requisition No");
            }
            part(Passenger; "FLT-External Passengers")
            {
                Caption = 'External Passengers';
                ApplicationArea = basic;
                SubPageLink = "Transport No." = field("Transport Requisition No");
            }
        }
    }

    actions
    {
        area(processing)
        {

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
            separator(Action30) { }
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
            action("Mark As Complete")
            {
                ApplicationArea = Basic;
                Image = AddAction;
                ToolTip = 'Executes the Mark As Complete action.';

                trigger OnAction()
                begin
                    Rec.TestField("Vehicle Allocated");
                    Rec.TestField("Driver Allocated");
                    Rec.TestField("Opening Odometer Reading");
                    if Confirm('Do you really want to Close the requisition', false) then begin
                        if Rec.Status <> Rec.Status::Approved then Error('Please note that you can only close the approved requisition');
                        Rec.Status := Rec.Status::Closed;
                        Rec.Modify;
                    end;
                end;
            }

        }
    }

    var
        DocumentType: Option Quote,"Order",Invoice,"Credit Memo","Blanket Order","Return Order","None","Payment Voucher","Petty Cash",Imprest,Requisition,ImprestSurrender,Interbank,TransportRequest,Maintenance,Fuel,ImporterExporter,"Import Permit","Export Permit",TR,"Safari Notice","Student Applications","Water Research","Consultancy Requests","Consultancy Proposals","Meals Bookings","General Journal","Student Admissions","Staff Claim",KitchenStoreRequisition,"Leave Application";
        ApprovalEntries: Page "Approval Entries";
}

