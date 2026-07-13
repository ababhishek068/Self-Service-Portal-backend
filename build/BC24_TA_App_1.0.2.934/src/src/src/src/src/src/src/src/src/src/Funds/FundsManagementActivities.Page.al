Page 50863 "Funds Management Activities"
{
    Caption = 'Activities';
    PageType = CardPart;
    SourceTable = "Funds Management Cue";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            cuegroup(PendingPaymentDocuments)
            {
                Caption = 'Pending Payment Documents';
                field(InterbankTransfers; Rec."Interbank Not Posted")
                {
                    ApplicationArea = Basic;
                    Caption = 'Interbank Transfers';
                    ToolTip = 'Specifies the value of the Interbank Transfers field.';
                }
                field(PaymentVouchers; Rec."PV Not Posted")
                {
                    ApplicationArea = Basic;
                    Caption = 'Payment Vouchers';
                    ToolTip = 'Specifies the value of the Payment Vouchers field.';
                }
                field(PettyCashVouchers; Rec."PCV Not Posted")
                {
                    ApplicationArea = Basic;
                    Caption = 'Petty Cash Vouchers';
                    ToolTip = 'Specifies the value of the Petty Cash Vouchers field.';
                }
                field("Unpaid Invoices"; Rec."Unpaid Invoices")
                {
                    ApplicationArea = Basic;
                    Caption = 'Unpaid Invoices';
                    ToolTip = 'Specifies the value of the Unpaid Invoices field.';
                }
                /* field(StoreRequisitions; "Store Req. Not Posted")
                {
                    ApplicationArea = Basic;
                    Caption = 'Store Requisitions';
                } */

                actions
                {
                    action(BankCashTransfer)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Bank & Cash Transfer';
                        RunObject = Page "Interbank Transfer";
                        ToolTip = 'Executes the Bank & Cash Transfer action.';
                    }
                    action(Receipt)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Receipt';
                        RunObject = Page "Receipts List";
                        RunPageView = where(Posted = const(false));
                        ToolTip = 'Executes the Receipt action.';
                    }
                    action("Payment Voucher ")
                    {
                        ApplicationArea = Basic;
                        Caption = 'Payment Vouchers';
                        Image = TileBrickNew;
                        RunObject = Page "Payment Vouchers List";
                        ToolTip = 'Executes the Payment Vouchers action.';
                    }
                    action("Petty Cash Vouchers")
                    {
                        ApplicationArea = Basic;
                        RunObject = Page "Petty Cash";
                        ToolTip = 'Executes the Petty Cash Vouchers action.';
                    }
                }
            }
            /* cuegroup(PendingTravelDocuments)
            {
                Caption = 'Pending Travel Documents';
                field(TravelAdvance; "Staff Travel Not Posted")
                {
                    ApplicationArea = Basic;
                    Caption = 'Travel Advance';
                }
                field(TravelAccounting; "Staff TA Not Posted")
                {
                    ApplicationArea = Basic;
                    Caption = 'Travel Accounting';
                }
                field(OtherAdvance; "Other Advance Not Posted")
                {
                    ApplicationArea = Basic;
                    Caption = 'Other Advance';
                }
                field(StaffClaim; "Staff Claim Not Posted")
                {
                    ApplicationArea = Basic;
                    Caption = 'Staff Claim';
                }

                actions
                {
                    action(StaffTravelAdvance)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Staff Travel Advance';
                        RunObject = Page "Travel Advance Vouchers List";
                    }
                    action(TravelAdvanceAccounting)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Travel Advance Accounting';
                        RunObject = Page "Travel Advances Acct. List";
                    }
                    action(StaffClaims)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Staff Claims';
                        RunObject = Page "Staff Claim List";
                    }
                    action(OtherAdvances)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Other Advances';
                        RunObject = Page "Staff Advance Request List";
                    }
                    action(OtherAdvancesAccounting)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Other Advances Accounting';
                        RunObject = Page "Staff Advance Surrender List";
                    }
                }
            } */
            cuegroup(DocumentApproval)
            {
                Caption = 'Document Approval';
                field(InterbankPendingApproval; Rec."Interbank Pending Approval")
                {
                    ApplicationArea = Basic;
                    Caption = 'Interbank Transfers';
                    ToolTip = 'Specifies the value of the Interbank Transfers field.';
                }
                field(PVPendingApproval; Rec."PV Pending Approval")
                {
                    ApplicationArea = Basic;
                    Caption = 'Payment Vouchers';
                    ToolTip = 'Specifies the value of the Payment Vouchers field.';
                }
                field(PCVPendingApproval; Rec."PCV Pending Approval")
                {
                    ApplicationArea = Basic;
                    Caption = 'Petty Cash Vouchers';
                    ToolTip = 'Specifies the value of the Petty Cash Vouchers field.';
                }
                /* field(StaffTravelPendingApproval; "Staff Travel Pending Approval")
                {
                    ApplicationArea = Basic;
                    Caption = 'Staff Travel Advance';
                }
                field(StaffTravelAdvanceAccounting; "Staff TA Pending Approval")
                {
                    ApplicationArea = Basic;
                    Caption = 'Staff Travel Advance Accounting';
                } */
                field(ApprovalEntries; Rec."Approval Entries")
                {
                    ApplicationArea = Basic;
                    Caption = 'Approval Entries';
                    DrillDownPageID = "Approval Entries";
                    LookupPageID = "Approval Entries";
                    ToolTip = 'Specifies the value of the Approval Entries field.';
                }
            }
            cuegroup(Control30)
            {
                field(OtherAdvancePendingApproval; Rec."Other Advance Pending Approval")
                {
                    ApplicationArea = Basic;
                    Caption = 'Other Advance';
                    ToolTip = 'Specifies the value of the Other Advance field.';
                }
                field(StaffClaimPendingApproval; Rec."Staff Claim Pending Approval")
                {
                    ApplicationArea = Basic;
                    Caption = 'Staff Claims';
                    ToolTip = 'Specifies the value of the Staff Claims field.';
                }
                field(PurchaseRequisitions; Rec."Requisitions Pending Approval")
                {
                    ApplicationArea = Basic;
                    Caption = 'Purchase Requisitions';
                    ToolTip = 'Specifies the value of the Purchase Requisitions field.';
                }
                field(StoreReqPendingApproval; Rec."Store Req. Pending Approval")
                {
                    ApplicationArea = Basic;
                    Caption = 'Store Requisitions';
                    ToolTip = 'Specifies the value of the Store Requisitions field.';
                }
            }
        }
    }

    actions { }

    trigger OnOpenPage()
    begin
        Rec.Reset;
        if not Rec.Get then begin
            Rec.Init;
            Rec.Insert;
        end;

        Rec.SetFilter("Due Date Filter", '<=%1', WorkDate);
        Rec.SetFilter("Overdue Date Filter", '<%1', WorkDate);
    end;
}

