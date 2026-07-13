page 50677 "Document Attachments"
{
    Caption = 'Documents Attached';
    PageType = CardPart;
    SourceTable = "Document Attachment";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            group(Control2)
            {
                ShowCaption = false;
                field(Documents; Rec.Count)
                {
                    ApplicationArea = All;
                    Caption = 'Documents';
                    StyleExpr = TRUE;
                    ToolTip = 'Specifies the number of attachments.';

                    trigger OnDrillDown()
                    var
                        Customer: Record Customer;
                        Vendor: Record Vendor;
                        Item: Record Item;
                        Employee: Record "HR-Employee";
                        FixedAsset: Record "Fixed Asset";
                        Resource: Record Resource;
                        SalesHeader: Record "Sales Header";
                        PurchaseHeader: Record "Purchase Header";
                        Job: Record Job;
                        SalesCrMemoHeader: Record "Sales Cr.Memo Header";
                        SalesInvoiceHeader: Record "Sales Invoice Header";
                        PurchInvHeader: Record "Purch. Inv. Header";
                        PurchCrMemoHdr: Record "Purch. Cr. Memo Hdr.";
                        ImpHeader: Record "Imprest Header";
                        ImpSurrHeader: Record "Imprest Surrender Header";
                        StaffClaim: Record "Staff Claims Header";
                        Conf: Record "Conference Attendance";
                        Jb: Record jobs;
                        JobApp: Record "Applicant Register";
                        HRJobApp: Record "HR Job Applicants";
                        PV: record "Payments Header";
                        ImpMemo: record "Imprest Memo Header";
                        Servicetrans: record "Service Transfer Header";
                        DocumentAttachmentDetails: Page "Document Attachment Det Custom";
                        InterBank: Record "InterBank Transfers";
                        RecRef: RecordRef;
                        ICTReq: Record "ICT General Requisition Header";
                        
                    begin
                        case Rec."Table ID" of
                            DATABASE::Customer:
                                begin
                                    RecRef.Open(DATABASE::Customer);
                                    if Customer.Get(Rec."No.") then
                                        RecRef.GetTable(Customer);
                                end;
                            DATABASE::Vendor:
                                begin
                                    RecRef.Open(DATABASE::Vendor);
                                    if Vendor.Get(Rec."No.") then
                                        RecRef.GetTable(Vendor);
                                end;
                            DATABASE::Item:
                                begin
                                    RecRef.Open(DATABASE::Item);
                                    if Item.Get(Rec."No.") then
                                        RecRef.GetTable(Item);
                                end;
                            DATABASE::Employee:
                                begin
                                    RecRef.Open(DATABASE::Employee);
                                    if Employee.Get(Rec."No.") then
                                        RecRef.GetTable(Employee);
                                end;
                            DATABASE::"InterBank Transfers":
                                begin
                                    RecRef.Open(DATABASE::"InterBank Transfers");
                                    if InterBank.Get(Rec."No.") then
                                        RecRef.GetTable(InterBank);
                                end;

                            DATABASE::"Fixed Asset":
                                begin
                                    RecRef.Open(DATABASE::"Fixed Asset");
                                    if FixedAsset.Get(Rec."No.") then
                                        RecRef.GetTable(FixedAsset);
                                end;
                            DATABASE::Resource:
                                begin
                                    RecRef.Open(DATABASE::Resource);
                                    if Resource.Get(Rec."No.") then
                                        RecRef.GetTable(Resource);
                                end;
                            DATABASE::"Imprest Header":
                                begin
                                    RecRef.Open(DATABASE::"Imprest Header");
                                    if ImpHeader.Get(Rec."No.") then
                                        RecRef.GetTable(ImpHeader);
                                end;
                            DATABASE::"Payments Header":
                                begin
                                    RecRef.Open(DATABASE::"Payments Header");
                                    if PV.Get(Rec."No.") then
                                        RecRef.GetTable(PV);
                                end;
                            DATABASE::"Imprest Surrender Header":
                                begin
                                    RecRef.Open(DATABASE::"Imprest Surrender Header");
                                    if ImpSurrHeader.Get(Rec."No.") then
                                        RecRef.GetTable(ImpSurrHeader);
                                end;
                            DATABASE::"Staff Claims Header":
                                begin
                                    RecRef.Open(DATABASE::"Staff Claims Header");
                                    if StaffClaim.Get(Rec."No.") then
                                        RecRef.GetTable(StaffClaim);
                                end;
                            DATABASE::"Imprest Memo Header":
                                begin
                                    RecRef.Open(DATABASE::"Imprest Memo Header");
                                    if ImpMemo.Get(Rec."No.") then
                                        RecRef.GetTable(ImpMemo);
                                end;
                            DATABASE::Job:
                                begin
                                    RecRef.Open(DATABASE::Job);
                                    if Job.Get(Rec."No.") then
                                        RecRef.GetTable(Job);
                                end;
                            DATABASE::Jobs:
                                begin
                                    RecRef.Open(DATABASE::Jobs);
                                    if Jb.Get(Rec."No.") then
                                        RecRef.GetTable(Jb);
                                end;
                            DATABASE::"Conference Attendance":
                                begin
                                    RecRef.Open(DATABASE::"Conference Attendance");
                                    if Conf.Get(Rec."No.") then
                                        RecRef.GetTable(Conf);
                                end;
                            DATABASE::"Applicant Register":
                                begin
                                    RecRef.Open(DATABASE::"Applicant Register");
                                    if JobApp.Get(Rec."No.") then
                                        RecRef.GetTable(JobApp);
                                end;
                            DATABASE::"ICT General Requisition Header":
                                begin
                                    RecRef.Open(DATABASE::"ICT General Requisition Header");
                                    if ICTReq.Get(Rec."No.") then
                                        RecRef.GetTable(ICTReq);
                                end;

                            DATABASE::"HR Job Applicants":
                                begin
                                    RecRef.Open(DATABASE::"HR Job Applicants");
                                    if HRJobApp.Get(Rec."No.") then
                                        RecRef.GetTable(HRJobApp);
                                end;
                            DATABASE::"Sales Header":
                                begin
                                    RecRef.Open(DATABASE::"Sales Header");
                                    if SalesHeader.Get(Rec."Document Type", Rec."No.") then
                                        RecRef.GetTable(SalesHeader);
                                end;
                            DATABASE::"Sales Invoice Header":
                                begin
                                    RecRef.Open(DATABASE::"Sales Invoice Header");
                                    if SalesInvoiceHeader.Get(Rec."No.") then
                                        RecRef.GetTable(SalesInvoiceHeader);
                                end;
                            DATABASE::"Sales Cr.Memo Header":
                                begin
                                    RecRef.Open(DATABASE::"Sales Cr.Memo Header");
                                    if SalesCrMemoHeader.Get(Rec."No.") then
                                        RecRef.GetTable(SalesCrMemoHeader);
                                end;
                            DATABASE::"Purchase Header":
                                begin
                                    RecRef.Open(DATABASE::"Purchase Header");
                                    if PurchaseHeader.Get(Rec."Document Type", Rec."No.") then
                                        RecRef.GetTable(PurchaseHeader);
                                end;
                            DATABASE::"Purch. Inv. Header":
                                begin
                                    RecRef.Open(DATABASE::"Purch. Inv. Header");
                                    if PurchInvHeader.Get(Rec."No.") then
                                        RecRef.GetTable(PurchInvHeader);
                                end;
                            DATABASE::"Purch. Cr. Memo Hdr.":
                                begin
                                    RecRef.Open(DATABASE::"Purch. Cr. Memo Hdr.");
                                    if PurchCrMemoHdr.Get(Rec."No.") then
                                        RecRef.GetTable(PurchCrMemoHdr);
                                end;
                            DATABASE::"Service Transfer Header":
                                begin
                                    RecRef.Open(DATABASE::"Service Transfer Header");
                                    if Servicetrans.Get(Rec."No.") then
                                        RecRef.GetTable(Servicetrans);
                                end;

                            else
                                OnBeforeDrillDown(Rec, RecRef);
                        end;

                        DocumentAttachmentDetails.OpenForRecRef(RecRef);
                        DocumentAttachmentDetails.RunModal;
                    end;
                }
            }
        }
    }

    actions { }

    [IntegrationEvent(false, false)]
    local procedure OnBeforeDrillDown(DocumentAttachment: Record "Document Attachment"; var RecRef: RecordRef)
    begin
    end;
}
