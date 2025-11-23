## To repozytorium zawiera dokumentację również w języku polskim, która znajduje się poniżej.

# EN / WayWalker – Real-Time Mock Location Simulator

WayWalker is a Flutter-based utility app designed to simulate real-time movement and mock GPS locations.
It allows you to generate controlled position updates—ideal for testing location-based apps, navigation flows, geofencing logic, and motion-driven UI without needing to physically move.

The app provides a simple UI, real-time coordinate updates, and customizable movement simulation logic, making it a valuable tool for mobile developers.

# 🚀 Features

    1. Real-Time Location Mocking
    
    	•	Updates device location programmatically in real-time
    	•	Sends continuous position changes as if the user were physically moving
    	•	Works with apps that rely on GPS or geolocation streams
    
    2. Movement Simulation
    
    	•	Automatically simulates forward movement from the user’s current location
    	•	Supports fixed-distance simulations (e.g., 200 meters forward and back)
    	•	Smooth interpolation between points for realistic movement
    
    3. Simulation Screen
    
    	•	Live preview of simulated movement
    	•	Start/Stop controls
    	•	Displays current simulated coordinates
    
    4. Customizable Behavior
    
    	•	Adjustable movement speed
    	•	Adjustable movement distance
    	•	Easy to plug into location-based apps

# 📋 Requirements

## Functional Requirements
	1.	The system must allow starting and stopping a movement simulation.

	2.	The app must generate a series of GPS points at a constant interval.

	3.	The simulation must:

        •	Move forward a specified distance
        •	Reverse back to the starting point

	4.	The UI must display simulated coordinates in real-time.

	5.	The movement engine must expose a stream of position updates for external apps.

## Non-Functional Requirements
	1.	Performance

        •	Simulation must run smoothly at 30–60 updates per second.
        •	Location updates must not freeze the UI.

	2.	Maintainability

        •	Code structured into clean, logical modules (UI, simulation logic, entry point).
        •	Clear separation between UI and simulation engine.

	3.	Scalability

        •	MovementAlgorithms should be extendable (e.g., random routes, circle paths).
        •	Easy to integrate with real GPS providers.

	4.	Portability

        •	Must run on Android (with mock location enabled).
        •	Flutter structure supports future iOS & web compatibility.

	5.	Usability

        •	Intuitive UI for enabling and visualizing simulation.
        •	Simple two-button control: Start / Stop.

# 🧩 Architecture

WayWalker follows a lightweight, modular architecture optimized for utilities and tooling.

## lib/
    •	main.dart | Entry point, initializes the app and navigation.

    •	my_home_page.dart | UI for starting simulations, configuration, and quick access.

    •	simulation_screen.dart | Dedicated screen showing live movement updates.

    •	movement_simulation.dart | Core simulation engine containing:

        •	position streams
        •	movement algorithms
        •	distance calculation
        •	timed updates

## Architecture Characteristics
	•	Clear separation between UI and simulation logic
	•	Simulation runs independently from the widget lifecycle
	•	Uses Streams for real-time coordinate updates
	•	Modular and easily extendable (e.g., custom paths, speed profiles)

# 🔧 Technologies
	•	Flutter — cross-platform UI framework
	•	Dart — main programming language
	•	Stream API — real-time movement updates
	•	Geolocation math — distance and bearing calculations
	•	Mock-location support (Android) — allows overriding system GPS

**────────────────────────**

# 🇵🇱 PL / WayWalker – Symulator Ruchu i Mockowanej Lokalizacji GPS w Czasie Rzeczywistym

WayWalker to aplikacja narzędziowa stworzona we Flutterze, umożliwiająca symulowanie ruchu i generowanie mockowanych lokalizacji GPS w czasie rzeczywistym.
Pozwala tworzyć kontrolowane aktualizacje pozycji, co jest idealne do testowania aplikacji opartych o geolokalizację, nawigację, geofencing oraz interfejsy zależne od ruchu — bez potrzeby fizycznego przemieszczania się.

Aplikacja oferuje prosty interfejs, aktualizacje współrzędnych w czasie rzeczywistym oraz konfigurowalną logikę symulacji ruchu.


# 🚀 Funkcje

    1. Symulacja Lokalizacji w Czasie Rzeczywistym

        •	Programowe aktualizowanie lokalizacji urządzenia
        •	Ciągłe zmiany pozycji imitujące rzeczywisty ruch
        •	Działa z aplikacjami korzystającymi z GPS i streamów geolokalizacji

    2. Symulacja Ruchu

        •	Automatyczne przesuwanie pozycji użytkownika do przodu od punktu startowego
        •	Obsługa symulacji na określoną odległość (np. 200 m w przód i z powrotem)
        •	Płynna interpolacja między punktami dla realistycznego efektu

    3. Ekran Symulacji

        •	Podgląd ruchu w czasie rzeczywistym
        •	Przyciski Start / Stop
        •	Wyświetlanie aktualnych współrzędnych

    4. Konfigurowalne Zachowanie

        •	Regulowana prędkość ruchu
        •	Regulowana odległość symulacji
        •	Łatwa integracja z aplikacjami lokalizacyjnymi

# 📋 Wymagania

## Wymagania Funkcjonalne
	1.	Aplikacja musi umożliwiać rozpoczęcie i zatrzymanie symulacji ruchu.

	2.	System musi generować kolejne punkty GPS w stałych odstępach czasu.

	3.	Symulacja musi:

        •	przesuwać użytkownika do przodu o określoną odległość,
        •	wracać do punktu początkowego.

	4.	UI musi wyświetlać bieżące współrzędne w czasie rzeczywistym.

	5.	Silnik symulacji musi udostępniać stream z aktualizacjami pozycji dla zewnętrznych modułów.

## Wymagania Niefunkcjonalne

    1. Wydajność

        •	Symulacja musi działać płynnie (30–60 FPS).
        •	Aktualizacje lokalizacji nie mogą blokować UI.

    2. Utrzymywalność

        •	Kod podzielony na moduły (UI, logika symulacji, punkt startowy).
        •	Jasne oddzielenie warstwy interfejsu od logiki symulacji.

    3. Skalowalność

        •	Możliwość rozszerzenia MovementAlgorithms (np. o trasy losowe, ruch po okręgu).
        •	Łatwa integracja z prawdziwymi usługami GPS.

    4. Przenośność

        •	Wsparcie dla Androida (z włączonym mockowaniem lokalizacji).
        •	Struktura Fluttera umożliwia przyszłe wsparcie iOS i Web.

    5. Użyteczność

        •	Intuicyjny interfejs do uruchamiania symulacji.
        •	Prosty system Start / Stop.

# 🧩 Architektura

WayWalker wykorzystuje lekką, modularną architekturę zoptymalizowaną dla aplikacji narzędziowych.

## lib/
	•	main.dart | Punkt wejścia, inicjuje aplikację i nawigację.

	•	my_home_page.dart | UI do uruchamiania symulacji i konfiguracji.

	•	simulation_screen.dart | Ekran prezentujący ruch w czasie rzeczywistym.

	•	movement_simulation.dart | Silnik symulacji odpowiedzialny za:

        •	generowanie streamów pozycji,
        •	algorytmy ruchu,
        •	obliczenia odległości,
        •	aktualizacje czasowe.

## Cechy Architektury
	•	Wyraźny podział między UI a logiką symulacji
	•	Niezależne działanie symulacji od cyklu życia widżetów
	•	Aktualizacje pozycji oparte o Streamy
	•	Łatwa rozszerzalność (profile prędkości, własne trasy, generowanie losowe)

# 🔧 Technologie
	•	Flutter — framework wieloplatformowy
	•	Dart — główny język programowania
	•	Stream API — aktualizacje pozycji w czasie rzeczywistym
	•	Geolokacja — obliczanie dystansu, kierunku i interpolacji
	•	Mock Location (Android) — zastępowanie systemowej lokalizacji GPS
