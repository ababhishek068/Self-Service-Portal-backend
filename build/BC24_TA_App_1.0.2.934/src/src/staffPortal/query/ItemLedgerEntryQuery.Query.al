namespace Hijra.Hijra;

using Microsoft.Inventory.Ledger;

query 50096 "Item Ledger Entry Query"
{
    Caption = 'Item Ledger Entry Query';
    QueryType = Normal;
    
    elements
    {
        dataitem(ItemLedgerEntry; "Item Ledger Entry")
        {
            column(EntryNo; "Entry No.")
            {
            }
            column(ItemNo; "Item No.")
            {
            }
            column(PostingDate; "Posting Date")
            {
            }
            column(EntryType; "Entry Type")
            {
            }
            column(SourceNo; "Source No.")
            {
            }
            column(DocumentNo; "Document No.")
            {
            }
            column(Description; Description)
            {
            }
            column(LocationCode; "Location Code")
            {
            }
            column(Quantity; Quantity)
            {
            }
            column(RemainingQuantity; "Remaining Quantity")
            {
            }
            column(InvoicedQuantity; "Invoiced Quantity")
            {
            }
            column(AppliestoEntry; "Applies-to Entry")
            {
            }
            column(Open; Open)
            {
            }
            column(GlobalDimension1Code; "Global Dimension 1 Code")
            {
            }
            column(GlobalDimension2Code; "Global Dimension 2 Code")
            {
            }
            column(Positive; Positive)
            {
            }
            column(ShptMethodCode; "Shpt. Method Code")
            {
            }
            column(SourceType; "Source Type")
            {
            }
            column(DropShipment; "Drop Shipment")
            {
            }
            column("TransactionType"; "Transaction Type")
            {
            }
            column(TransportMethod; "Transport Method")
            {
            }
            column(CountryRegionCode; "Country/Region Code")
            {
            }
            column(EntryExitPoint; "Entry/Exit Point")
            {
            }
            column(DocumentDate; "Document Date")
            {
            }
            column(ExternalDocumentNo; "External Document No.")
            {
            }
            column("Area"; "Area")
            {
            }
            column(TransactionSpecification; "Transaction Specification")
            {
            }
            column(NoSeries; "No. Series")
            {
            }
            column(ReservedQuantity; "Reserved Quantity")
            {
            }
            column(DocumentType; "Document Type")
            {
            }
            column(DocumentLineNo; "Document Line No.")
            {
            }
            column(OrderType; "Order Type")
            {
            }
            column(OrderNo; "Order No.")
            {
            }
            column(OrderLineNo; "Order Line No.")
            {
            }
            column(DimensionSetID; "Dimension Set ID")
            {
            }
            column(ShortcutDimension3Code; "Shortcut Dimension 3 Code")
            {
            }
            column(ShortcutDimension4Code; "Shortcut Dimension 4 Code")
            {
            }
            column(ShortcutDimension5Code; "Shortcut Dimension 5 Code")
            {
            }
            column(ShortcutDimension6Code; "Shortcut Dimension 6 Code")
            {
            }
            column(ShortcutDimension7Code; "Shortcut Dimension 7 Code")
            {
            }
            column(ShortcutDimension8Code; "Shortcut Dimension 8 Code")
            {
            }
            column(AssembletoOrder; "Assemble to Order")
            {
            }
            column(JobNo; "Job No.")
            {
            }
            column(JobTaskNo; "Job Task No.")
            {
            }
            column(JobPurchase; "Job Purchase")
            {
            }
            column(VariantCode; "Variant Code")
            {
            }
            column(QtyperUnitofMeasure; "Qty. per Unit of Measure")
            {
            }
            column(UnitofMeasureCode; "Unit of Measure Code")
            {
            }
            column(DerivedfromBlanketOrder; "Derived from Blanket Order")
            {
            }
            column(OriginallyOrderedNo; "Originally Ordered No.")
            {
            }
            column(OriginallyOrderedVarCode; "Originally Ordered Var. Code")
            {
            }
            column(OutofStockSubstitution; "Out-of-Stock Substitution")
            {
            }
            column(ItemCategoryCode; "Item Category Code")
            {
            }
            column(Nonstock; Nonstock)
            {
            }
            column(PurchasingCode; "Purchasing Code")
            {
            }
            column(ItemReferenceNo; "Item Reference No.")
            {
            }
            column(CompletelyInvoiced; "Completely Invoiced")
            {
            }
            column(LastInvoiceDate; "Last Invoice Date")
            {
            }
            column(AppliedEntrytoAdjust; "Applied Entry to Adjust")
            {
            }
            column(CostAmountExpected; "Cost Amount (Expected)")
            {
            }
            column(CostAmountActual; "Cost Amount (Actual)")
            {
            }
            column(CostAmountNonInvtbl; "Cost Amount (Non-Invtbl.)")
            {
            }
            column(CostAmountExpectedACY; "Cost Amount (Expected) (ACY)")
            {
            }
            column(CostAmountActualACY; "Cost Amount (Actual) (ACY)")
            {
            }
            column(CostAmountNonInvtblACY; "Cost Amount (Non-Invtbl.)(ACY)")
            {
            }
            column(PurchaseAmountExpected; "Purchase Amount (Expected)")
            {
            }
            column(PurchaseAmountActual; "Purchase Amount (Actual)")
            {
            }
            column(SalesAmountExpected; "Sales Amount (Expected)")
            {
            }
            column(SalesAmountActual; "Sales Amount (Actual)")
            {
            }
            column(Correction; Correction)
            {
            }
            column(ShippedQtyNotReturned; "Shipped Qty. Not Returned")
            {
            }
            column(ProdOrderCompLineNo; "Prod. Order Comp. Line No.")
            {
            }
            column(SerialNo; "Serial No.")
            {
            }
            column(LotNo; "Lot No.")
            {
            }
            column(WarrantyDate; "Warranty Date")
            {
            }
            column(ExpirationDate; "Expiration Date")
            {
            }
            column(ItemTracking; "Item Tracking")
            {
            }
            column(PackageNo; "Package No.")
            {
            }
            column(ReturnReasonCode; "Return Reason Code")
            {
            }
            column(SystemId; SystemId)
            {
            }
        }
    }
    
    trigger OnBeforeOpen()
    begin
    
    end;
}
