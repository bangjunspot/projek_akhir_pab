-- ============================================================
-- Fix RLS checkout stok
-- Tujuan: kasir bisa insert stock_movements type 'out' saat checkout
-- ============================================================

drop policy if exists "stock out insert authenticated" on stock_movements;

create policy "stock out insert authenticated" on stock_movements
for insert
with check (
  auth.uid() is not null
  and type = 'out'
  and qty > 0
  and product_id is not null
);

