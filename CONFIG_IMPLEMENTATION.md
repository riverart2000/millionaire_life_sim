# Configuration Implementation Fix

## Overview
Fixed the application to use values from `assets/config/default_settings.json` instead of hardcoded constants. Previously, the config file existed but was not being used by the core services.

## Changes Made

### 1. Bootstrap Provider (`lib/providers/bootstrap_provider.dart`)
**Before:**
- Hardcoded `dailyIncome: 200`
- Used `JarConstants.defaultPercentages` for jar allocation

**After:**
- Loads `AppConfig` at initialization
- Uses `config.income.dailyIncome` (2000)
- Uses `config.jarPercentages` for jar allocation
- Uses `config.income.autoSimulateDaily` flag

**Impact:** New users now start with correct income and jar percentages from config

### 2. Bills Service (`lib/services/bills_service.dart`)
**Before:**
- Hardcoded default bills at 10.0 each (rent, food, travel, accessories)

**After:**
- Loads config values: 100.0 each
- Added optional `AppConfig` parameter to constructor
- Created `_getDefaultBills()` helper method

**Impact:** Bills now default to config values (100.0 instead of 10.0) - 10x increase

### 3. Interest Service (`lib/services/interest_service.dart`)
**Before:**
- Hardcoded rates: FFA 0.003, LTSS 0.004, EDU 0.002

**After:**
- Uses config values converted to decimals: FFA 0.003 (0.3/100), LTSS 0.004 (0.4/100), EDU 0.002 (0.2/100)
- Added optional `AppConfig` parameter to constructor
- Created `_getDefaultRates()` helper method

**Impact:** Interest rates now match config percentages

### 4. Investment Return Service (`lib/services/investment_return_service.dart`)
**Before:**
- Hardcoded rates: GOLD 0.001, SILVER 0.001, BTC 0.002, REALESTATE 0.005

**After:**
- Uses config values converted to decimals: GOLD 0.001 (0.1/100), SILVER 0.001 (0.1/100), BTC 0.002 (0.2/100), REALESTATE 0.005 (0.5/100)
- Added optional `AppConfig` parameter to constructor
- Created `_getDefaultRates()` helper method

**Impact:** Investment returns now match config percentages

### 5. Jar Service (`lib/services/jar_service.dart`)
**Before:**
- Used `JarConstants.defaultPercentages` as fallback
- Jar percentages: FFA 25%, LTSS 25%, EDU 20%, NEC 55%, PLAY 10%, GIVE 5%

**After:**
- Uses `config.jarPercentages` as fallback
- Jar percentages: FFA 25%, LTSS 25%, EDU 20%, NEC 15%, PLAY 10%, GIVE 5%
- Added optional `AppConfig` parameter to constructor
- Removed import of `jar_constants.dart`

**Impact:** NEC jar allocation fixed from 55% to 15% per config

## Configuration Values

All services now use these values from `assets/config/default_settings.json`:

### Income
- Daily Income: **£2000** (was 200)
- Auto Simulate Daily: **true**

### Bills (Daily)
- Rent: **£100** (was 10)
- Food: **£100** (was 10)
- Travel: **£100** (was 10)
- Accessories: **£100** (was 10)

### Interest Rates (Daily %)
- FFA: **0.3%** (0.003)
- LTSS: **0.4%** (0.004)
- EDU: **0.2%** (0.002)

### Investment Returns (Daily %)
- GOLD: **0.1%** (0.001)
- SILVER: **0.1%** (0.001)
- BTC: **0.2%** (0.002)
- REALESTATE: **0.5%** (0.005)

### Jar Percentages
- FFA (Financial Freedom Account): **25%**
- LTSS (Long-Term Savings for Spending): **25%**
- EDU (Education): **20%**
- NEC (Necessities): **15%** (was 55%)
- PLAY (Play): **10%**
- GIVE (Give): **5%**

## Benefits

1. **Easy Configuration:** Users can now edit `default_settings.json` to customize game values
2. **Correct Values:** Fixed 10x difference in income/bills, corrected jar percentages
3. **Maintainability:** Single source of truth for configuration values
4. **Extensibility:** New config values can be added easily

## Testing

To verify the changes:
1. Delete the app data/reinstall to create a new user
2. Check that daily income is £2000 (not £200)
3. Verify bills are £100 each (not £10)
4. Confirm jar percentages match config (NEC should be 15%, not 55%)
5. Edit `default_settings.json` and restart app to see changes take effect

## Commit
- Commit: `7477aee`
- Message: "Implement config file usage across all services"
